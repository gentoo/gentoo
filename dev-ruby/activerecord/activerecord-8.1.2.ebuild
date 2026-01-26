# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

# this is not null so that the dependencies will actually be filled
RUBY_FAKEGEM_TASK_TEST="test"

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"

RUBY_FAKEGEM_GEMSPEC="activerecord.gemspec"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="https://github.com/rails/rails/"
SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~sparc ~x86"
IUSE="mysql postgres sqlite"

RUBY_S="rails-${PV}/${PN}"

ruby_add_rdepend "~dev-ruby/activesupport-${PV}
	~dev-ruby/activemodel-${PV}
	>=dev-ruby/timeout-0.4.0
	sqlite? ( >=dev-ruby/sqlite3-2.1 )
	mysql? ( dev-ruby/mysql2:0.5 )
	postgres? ( >=dev-ruby/pg-1.1:1 )"

ruby_add_bdepend "
	test? (
		dev-ruby/benchmark-ips
		dev-ruby/bundler
		~dev-ruby/actionpack-${PV}
		~dev-ruby/activejob-${PV}
		~dev-ruby/railties-${PV}
		>=dev-ruby/sqlite3-2.1
		dev-ruby/mocha
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
	)"

DEPEND+=" test? ( >=dev-db/sqlite-3.12.1 )"

all_ruby_prepare() {
	# Remove items from the common Gemfile that we don't need for this
	# test run. This also requires handling some gemspecs.
	rm ../Gemfile.lock || die
	sed -e "/\(uglifier\|system_timer\|sdoc\|w3c_validators\|pg\|jquery-rails\|execjs\|'mysql'\|journey\|ruby-prof\|stackprof\|benchmark-ips\|kindlerb\|turbolinks\|coffee-rails\|debugger\|redcarpet\|sprockets\|stackprof\)/ s:^:#:" \
		-e '/:job/,/end/ s:^:#:' \
		-e '/group :doc/,/^end/ s:^:#:' \
		-i ../Gemfile || die
	sed -e '/bcrypt/ s/3.0.0/3.0/' \
		-i ../Gemfile || die
	sed -i -e '/byebug/ s:^:#:' test/cases/base_prevent_writes_test.rb || die

	sed -e '2igem "minitest", "~> 6.0"; gem "minitest-mock"' \
		-i test/cases/helper.rb || die

	# Add back json in the Gemfile because we dropped some dependencies
	# earlier that implicitly required it.
	sed -i -e '$agem "json"' ../Gemfile || die

	# Avoid single tests using mysql or postgres dependencies.
	rm test/cases/invalid_connection_test.rb || die
	sed -e '/test_switching_connections_with_database_url/askip "postgres"' \
		-i test/cases/connection_adapters/connection_handlers_multi_db_test.rb || die

	# Avoid failing test that makes bad assumptions on database state.
	sed -i -e '/test_do_not_call_callbacks_for_delete_all/,/^  end/ s:^:#:' \
		test/cases/associations/has_many_associations_test.rb

	# Avoid test failing to bind limit length in favor of security release
	sed -i -e '/test_too_many_binds/askip "Fails on Gentoo"' test/cases/bind_parameter_test.rb || die

	# Avoid test requiring specific locales
	sed -i -e '/test_unicode_input_casting/askip "Requires specific locales"' test/cases/binary_test.rb || die

	# Avoid test not compatible with new sqlite versions
	sed -e '/test_strict_strings_by_default/askip "Fails with newer sqlite"' \
		-i test/cases/adapters/sqlite3/sqlite3_adapter_test.rb || die

	# Avoid tests requiring a full Rails setup
	rm -f test/cases/adapters/sqlite3/dbconsole_test.rb || die
}

each_ruby_test() {
	if use sqlite; then
		${RUBY} -S rake test_sqlite3 || die "sqlite3 tests failed"
	fi
}
