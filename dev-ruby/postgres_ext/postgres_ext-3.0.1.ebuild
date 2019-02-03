# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem eapi7-ver

DESCRIPTION="Native PostgreSQL data types and querying extensions for ActiveRecord and Arel"
HOMEPAGE="https://github.com/dockyard/postgres_ext"

LICENSE="BSD"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

# Requires live database connection
RESTRICT=test

ruby_add_rdepend "
		dev-ruby/activerecord:4.2
		>=dev-ruby/arel-4.0.1:*
		dev-ruby/pg_array_parser:0.0.9"

ruby_add_bdepend "dev-ruby/bundler"

all_ruby_prepare() {
	[ -f Gemfile.lock ] && rm Gemfile.lock
	#if ! use development; then
		sed -i -e "/^group :development do/,/^end$/d" Gemfile || die
		sed -i -e "/s.add_development_dependency/d" "${PN}".gemspec || die
		sed -i -e "/gem.add_development_dependency/d" "${PN}".gemspec || die
	#fi
	#if ! use test; then
		sed -i -e "/^group :test do/,/^end$/d" Gemfile || die
	#fi
	#if ! use test && ! use development; then
		sed -i -e "/^group :development, :test do/,/^end$/d" Gemfile || die
	#fi
		#https://github.com/dockyard/postgres_ext/issues/166
		#ugh, thanks
		sed -i -e "/byebug/d" Gemfile || die
		sed -i -e "/fivemat/d" Gemfile || die
}

each_ruby_prepare() {
	if [ -f Gemfile ]; then
		BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle install --local || die
		BUNDLE_GEMFILE=Gemfile ${RUBY} -S bundle check || die
	fi
}
