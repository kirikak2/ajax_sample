FROM ruby:2.4.4-slim
ENV BUILD_PACKAGES="ruby-dev bash build-essential" \
    DEV_PACKAGES="libxml2-dev libxslt-dev tzdata libv8-dev default-libmysqlclient-dev libsqlite3-dev" \
    RUBY_PACKAGES="ruby-json"

RUN apt-get update && \
    apt-get upgrade && \
    apt-get -y install $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES


WORKDIR /myapp
COPY . /myapp
EXPOSE 3000
RUN bundle config build.nokogiri --use-system-libraries \
	--use-system-libraries \
	--with-xml2-include=/usr/include/libxml2/ \
	--with-xslt-include=/usr/include/libxslt/ \
    && bundle install && bundle clean

CMD ["rails", "s", "-b", "0.0.0.0", "-p", "3000"]
