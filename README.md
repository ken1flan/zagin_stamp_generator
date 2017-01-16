# Zagin Stamp Generator

This is a web application of generating a cat image with your specified text.

## [Sample(Heroku)](https://zagin-stamp-generator.herokuapp.com/)

### Images
![Zagin Stamp Generator](http://zagin-stamp-generator.herokuapp.com/happi_coat?text=LGTM!&text_color=white&pattern=white&mirror_copy=no&font_name=NotoSansCJKjp-Black&size=Large)
![Zagin Stamp Generator](http://zagin-stamp-generator.herokuapp.com/cheers?text=Cheers!&text_color=white&pattern=white&mirror_copy=no&font_name=NotoSansCJKjp-Black&size=Large)

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
