# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

# this is not null so that the dependencies will actually be filled
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activerecord.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem eapi7-ver

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="https://github.com/rails/rails/"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux"
IUSE="mysql postgres sqlite"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "~dev-ruby/activesupport-${PV}
	~dev-ruby/activemodel-${PV}
	dev-ruby/arel:9.0
	sqlite? ( >=dev-ruby/sqlite3-1.3.6 )
	mysql? ( || ( dev-ruby/mysql2:0.4 >=dev-ruby/mysql2-0.3.18:0.3 ) )
	postgres? ( >=dev-ruby/pg-0.18.0:* )"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		~dev-ruby/actionpack-${PV}
		~dev-ruby/actionmailer-${PV}
		>=dev-ruby/sqlite3-1.3.6
		dev-ruby/mocha
		dev-ruby/minitest:5
	)"

DEPEND+=" test? ( >=dev-db/sqlite-3.12.1 )"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	rm ../Gemfile.lock || die
	sed -i -e "/\(uglifier\|system_timer\|sdoc\|w3c_validators\|pg\|jquery-rails\|execjs\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|redcarpet\|minitest\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' ../Gemfile || die
	sed -i -e '/rack-ssl/d' -e 's/~> 3.4/>= 3.4/' ../railties/railties.gemspec || die
	sed -i -e '/bcrypt/ s/3.0.0/3.0/' ../Gemfile || die

	# Add back json in the Gemfile because we dropped some dependencies
	# earlier that implicitly required it.
	sed -i -e '$agem "json"' ../Gemfile || die

	# Avoid test depending on mysql adapter which we don't support for
	# this Rails version to simplify our dependencies.
	rm test/cases/connection_specification/resolver_test.rb || die

	# Avoid single test using mysql dependencies.
	rm test/cases/invalid_connection_test.rb || die

	# Avoid failing test that makes bad assumptions on database state.
	sed -i -e '/test_do_not_call_callbacks_for_delete_all/,/^  end/ s:^:#:' \
		test/cases/associations/has_many_associations_test.rb
}

each_ruby_test() {
	if use sqlite; then
		${RUBY} -S rake test_sqlite3 || die "sqlite3 tests failed"
	fi
}
