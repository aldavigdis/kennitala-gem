# Kennitala

Process Icelandic kenntiala identification numbers.

The Gem provides a class to handle "kennitala" identifier codes and monkey patched the String class to that strings can be cast to Kennitala objects. The class can be used to sanitize the identifiers and read information like the date of birth (or date of registration in the case of companies and organization), age and the type of entity.

The class does not access external APIs or databases such as the National Registry or the Company Registry, so names and status (sex/gender, death, bankruptcy, credit rating etc.) cannot be accessed using the class. However, it can be used to sanitize and validate such data before being sent to external APIs, as such services are provided by private companies, which often charge a specific amount for each query.

## Uses of kennitala

Unlike the US Social Security number and equivalents, the kennitala is only used for identification of persons and companies (as well as other registered organizations) — and is often used internally by educational institutions, companies and other organization as a primary identifier for persons (e.g. school, employee, customer and frequent flyer ID). It is not to be used for authentication (i.e. a password) and is not considered a secret per se. While a kennitala can be kept unencrypted in a database, publishing a kennitala or a list of them is generally not considered good practice and might cause liability.

A kennitala is assigned to every newborn person and foreign national residing in Iceland as well as organizations and companies operating there. It is statically assigned and can not be changed.

Article II, paragraph 10 of the 77/2000 Act on Data Protection (http://www.althingi.is/lagas/nuna/2000077.html) provides the legal framework regarding the use and processing of the kennitala in Iceland:

> The use of a kennitala is allowed if it has a an objective cause and is necessary to ensure reliable identification of persons. The Data Protection Authority may ban or order the use of kennitala.

## Technicalities

The kennitala (`DDMMYY-RRCM`) is a 10-digit numeric string consisting on a date (date of birth for persons, date of registration for companies) in the form of `DDMMYY`, two random digits (`RR`) a check digit (`C`) and a century identifier (`M`). A hyphen or space is often added between the year and random values (Example: `010130-2989`).

The number 40 is added to the registration day of companies and organizations. Hence, a kennitala for a company registered at January 1 1990 starts with `410190` as opposed to `010190` for a person born that day.

The century identifier has 3 legal values. `8` for the 19th century, `9` for the 20th century and `0` for the 21st century.

## Examples

### Working with Kennitala objects

```ruby
# Initialize a Kennitala object.
# The string provided may include spaces, hyphens and alphabetical characters,
# which will then be erased from the resulting string.
k = Kennitala.new(' 010130-2989')
# => #<Kennitala:0x007fe35d041bc0 @value="0101302989">

# Invalid strings are rejected with an argument error
f = Kennitala.new('010130-2979')
# => ArgumentError: Kennitala is invalid

# If no kennitala string is specified, a random one will be generated
r = Kennitala.new
# => #<Kennitala:0x007fc589339f18 @value="2009155509">

# Retrieve the kennitala as a string.
# This is a sanitized string, without any non-numeric characters.
# Pretty useful when storing it in a database.
k.to_s
# => "0101302989"

# Pretty print the kennitala
# Adds a space between the 6th and the 7th digits for readability
k.pp
# => "010130 2989"

# You can also pass a string to .pp to use as a spacer
k.pp('–')
# => "010130-2989"

# You can also pass a cat to the .pp method
k.pp('🐈')
# => "010130🐈2989"

# Get the entity type (results in 'person' or 'company')
k.entity_type
# => "person"

# It's also possible to use .company? and .person? to achieve the same thing
k.company?
# => false

k.person?
# => true

# Cast the kennitala to a Date object
k.to_date
# => #<Date: 1930-01-01 ((2425978j,0s,0n),+0s,2299161j)>

# Get the current age of the entity. Useful for age restrictions.
k.age
# => 86
```

### Casting strings

```ruby
# Casting a string to a Kennitala object
'010130 2989'.to_kt
# => #<Kennitala:0x007fc5893286a0 @value="0101302989">

# Get the current age based on a String
'0101302989'.to_kt.age
# => 86
```

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle kennitala

If bundler is not being used to manage dependencies:

    $ gem install kennitala

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/aldavigdis/kennitala-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/aldavigdis/kennitala-gem/blob/master/CODE_OF_CONDUCT.md).

Don't be afraid of using Rubocop for correcting your code and to make it conform to the standards defined in `.rubocop.yml`. You will want to run `bundle exec rubocop -A` to see if your code has any errors and correct them on the fly.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kennitala project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/aldavigdis/kennitala-gem/blob/master/CODE_OF_CONDUCT.md).
