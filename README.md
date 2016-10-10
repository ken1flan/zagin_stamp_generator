# Zagin Stamp Generator

This is a web application of generating a cat image with your specified text.

## Sample(Heroku)

### Images
![Zagin Stamp Generator](https://zagin-stamp-generator.herokuapp.com/)
![Zagin Stamp Generator](https://zagin-stamp-generator.herokuapp.com?text=LGTM!)

### Form
https://zagin-stamp-generator.herokuapp.com/form

# Development

## Setup
Copy `dot.env` to `.env`
Set `DATABASE_URL`.

```bash
$ rake db:migrate
```

## Run server

```bash
$ bundle exec ruby web.rb
```

## Run tests
```bash
$ bundle exec rpec
```

# About Fonts
Use fonts the following, thanks a lot.
Their licences are Apache Licence 2.0.
* [Noto Sans CJK](http://www.google.com/get/noto/)
* [けいふぉんと](http://font.sumomo.ne.jp/font_1.html)
