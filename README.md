# BetterResponder

Small tweak for rendering decision.

## Getting started

How many times you may see in the controller the code like this:

```ruby
def create
  @post = @conversation.posts.build post_params
  @post.user = current_user
  if @post.save
    redirect_to @conversation, notice: I18n.t(...)
  else
    render :new
  end
end

def update
  if @post.update_attributes
    redirect_to @conversation, notice: I18n.t(...)
  else
    render :edit
  end
end

def destroy
  if @post.destroy
    redirect_to @conversation, notice: I18n.t(...)
  else
    redirect_to @conversation, alert: I18n.t(...)
  end
end
```

This code is valid but for me it contains some duplication and it needs to refactor.

## Installation

Add this line to your application's Gemfile:

    gem 'better_responder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install better_responder

Or if you want to stay on the edge:

    gem 'better_responder', github: 'sergio1990/better_responder'


## Usage

For first you need to initialize Responder object. At this time, I recommend you to do this in Application Controller:

```ruby
  before_action :create_responder #You must use before_filter for rails < 4

  private

  def create_responder
    @responder ||= BetterResponder::Responder.new(self)
  end
```

Next, refactor code that was shown earlier:

```ruby
  def create
    @post = @conversation.posts.new post_params
    @post.user = current_user
    @responder.run @post.save, {redirect_to: @conversation}, {render: :new}
  end

  def update
    @responder.run @post.update_attributes(post_params), {redirect_to: @conversation}, {render: :edit}
  end

  def destroy
    @responder.run @post.destroy, {redirect_to: @conversation}
  end
```

Now we simplify your code by calling single __@responder.run__. IMHO this looks small bit better. However, I dont like to manually calling @responder.run each time and this problem I will solve.

## Flash messages

For right using flash messages inside Responder you must declare translations accordingly this pattern:

```
  responder.#{controller_name}.#{action_name}.#{type}
```

Type is a finite set of _[success, fail]_.

For example:

```yaml
  ru:
    responder:
      posts:
        destroy:
          success: Your success message
          fail: Your fail message
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
