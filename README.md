[![Build Status](https://api.travis-ci.com/StaphSynth/has_protected_token.svg?branch=master)](https://travis-ci.com/StaphSynth/has_protected_token)
[![Gem Version](https://badge.fury.io/rb/has_protected_token.svg)](https://badge.fury.io/rb/has_protected_token)

# has_protected_token

## What?

Abstracts away generating, storing and validating user auth tokens. Use it if you need to deal with shared secrets, etc.

## Installation

Requirements: Ruby >= 2.3, ActiveRecord >= 4.2

From the command line:

```
$ gem install has_protected_token
```

In your project gemfile:

```ruby
gem 'has_protected_token'
```

## Usage

### Adding it to your model

Add it to your model as you would with `has_secure_password`:

```ruby
class User < ActiveRecord::Base
  has_protected_token
end
```

The gem assumes the existance of a `token` attribute on the model. If you would like to use a different name, you can pass an optional hash:

```ruby
has_protected_token column_name: :my_column_name
```

The gem will replace 'token' with 'my_column_name' in all instance methods described below. Thus, `#token` becomes `#my_column_name`, `#regenerate_token` becomes `#regenerate_my_column_name`, etc.

### Generating and validating tokens

To automatically generate a new random token and save it to your model, call `#regenerate_token`:

```ruby
user = User.new
user.regenerate_token
  # => 'e13d0bbd4a12d2aea673127c7e995a67'
user.token
  # => '$2a$12$5xVuny6Z79bYfgMMU7nyzeaOSjygRnXfsJjeJHzRZ0vUYRGeUjo6u'
```

If you would like to supply your own token:

```ruby
user = User.new
user.token = 'happiness is a cup of coffee'
  # => 'happiness is a cup of coffee'
user.save!
  # => true
user.token
  # => '$2a$12$5zWuBy3279hYfgOMU2nyz3aQWjygTnXfsJjeJHzRZ0vUYZGeUgY6W'
```

To validate a token against the hashed value stored in the database:

```ruby
user.validate_token('correct value')
  # => true
user.validate_token('incorrect value')
  # => false
```

### More advanced features

`has_protected_token` uses BCrypt to hash the token before storage. By default, it uses BCrypt's default cost (currently 12) during hashing. You can lower this value to speed up the hashing process at the cost of lower security, or raise it for the opposite effect. Simply add a `cost` parameter to the options hash when calling `has_protected_token`:

```ruby
has_protected_token cost: 16
```
