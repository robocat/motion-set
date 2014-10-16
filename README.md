# Implementation of Ruby `set` module

This gems implements `Set` class from `set` standard library
of Ruby 1.9.3. See [Ruby 1.9.3 `Set` API documentation](
http://ruby-doc.org/stdlib-1.9.3/libdoc/set/rdoc/Set.html#method-i-flatten-21)

## Installation

Add this line to your application's Gemfile:

    gem 'motion-set'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install motion-set

## Implementation details

### No `require`

RubyMotion does not support `require`. Instead, when you
install this gem, `Set` class will be globally available.

### `Set` is `NSMutableSet`

`Set` is implemented as an alias to `NSMutableSet`, which
it turn is extended to accomodate all Ruby set methods.
This is similar to how other RubyMotion data types
(like `Array`) are implemented.

Advantages of this approach are:

1. Interoperability with native APIs:
   * You can pass `Set` objects to APIs expecting `NSSet`
     or `NSMutableSet`.
   * Whenever a native API returns an `NSMutableSet` you
     can treat it as Ruby set.
2. There's no performance penalty, because there is no
   unnecessary indirection.

However, there are some things you need to note:

### No `nil` in sets

`NSMutableSet` does not support adding `nil` object,
which applies to your Ruby sets.

This could fail in subtle ways, for example if you try
to call `#map!` with a block which returns `nil`.

> This could have been avoided if the implementation
> checked when `nil` is added, and instead stored a
> private singelton sentinel fake nil object, which would
> be converted back to `nil` when necessary. However,
> this would create a challenge for interoperability
> with native APIs: what should this object represent
> in Objective-C world?
>
> If you have opinion on this, you are welcom to
> [comment on this issue](
> https://github.com/robocat/motion-set/issues/1).

### No `#divide` method

[`#divide`](
http://ruby-doc.org/stdlib-1.9.3/libdoc/set/rdoc/Set.html#method-i-divide)
method is not implemented. You are welcome to contribute.

### No `SortedSet`

[`SortedSet`](
http://ruby-doc.org/stdlib-1.9.3/libdoc/set/rdoc/SortedSet.html)
is not implemented. You are welcome to contribute.

### No Android support

There is no Android support, but you are welcome to
contribute.

## Contributing

1. Fork it
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Create new Pull Request
