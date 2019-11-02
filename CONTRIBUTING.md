# Contributing

Improvements, bug-fixes, suggestions, etc are very welcome. If it's your first time contributing to open-source, so much the better.

## Opening an issue

If you've found a bug or got an idea for something you'd like to see, please [open an issue](https://github.com/StaphSynth/has_protected_token/issues) on the github project page.

If you're reporting a bug, please provide the steps required to reproduce it and include your Ruby and ActiveRecord versions.

## Contributing code/documentation

All contributions are welcome, even if you're fixing a typo!

1. Fork the repository and run `$ bundle install`
2. Checkout a new branch and make your changes
3. [Open a pull request](https://github.com/StaphSynth/has_protected_token/pulls) on the github project page.

For those who are unfamiliar with the above workflow, or it's your first time contributing to open-source, there are some great [guides](https://github.com/collections/choosing-projects) available to help [get you started](https://github.com/FreeCodeCamp/how-to-contribute-to-open-source).

### Running the test suite

The simplest way is:

`$ rake test`

However, that command only runs the suite agains your current version of Ruby and ActiveRecord. Before opening a pull request, you may wish to run the full Travis-CI test suite which tests your code against multiple versions of Ruby and ActiveRecord. To do this, run:

`$ rake ci`

You'll want to make sure you have Ruby 2.3, 2.4, 2.5 and 2.6 installed first, though. (See [here](https://syntheta.se/coding/2018/12/09/getting-started-with-ruby.html) for a quick guide on setting up Ruby version management.)
