# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"
RUBY_FAKEGEM_GEMSPEC="activerecord.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit edo ruby-fakegem

DESCRIPTION="Implements the ActiveRecord pattern (Fowler, PoEAA) for ORM"
HOMEPAGE="https://github.com/rails/rails/"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~sparc ~x86"

IUSE="mysql postgres sqlite"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	~dev-ruby/activemodel-${PV}
	>=dev-ruby/timeout-0.4.0
	mysql? ( dev-ruby/mysql2:0.5 )
	postgres? ( >=dev-ruby/pg-1.1:1 )
	sqlite? ( >=dev-ruby/sqlite3-2.1 )
"
ruby_add_bdepend "
	test? (
		>=dev-ruby/bcrypt-ruby-3.1.11
		dev-ruby/bundler
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
		>=dev-ruby/msgpack-1.7.0
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 6.0"
	gem "minitest-mock"

	gem "bcrypt", "~> 3.1.11"
	gem "msgpack", ">= 1.7.0"

	$(usev mysql 'gem "mysql2", "~> 0.5"')
	$(usev postgres 'gem "pg", "~> 1.3"')
	$(usev sqlite 'gem "sqlite3", ">= 2.1"')
	EOF
	rm ../Gemfile.lock || die

	# Avoid single tests using mysql or postgres dependencies.
	rm test/cases/invalid_connection_test.rb || die
	sed -e '/test_switching_connections_with_database_url/askip "postgres"' \
		-i test/cases/connection_adapters/connection_handlers_multi_db_test.rb || die

	# Flaky with background system load
	sed -e '/test_checkout_fairness/,/^      end/ s:^:#:' \
		-i test/cases/connection_pool_test.rb || die
	sed -e '/"authenticate_by takes the same amount of time regardless of whether record is found"/,/^  end/ s:^:#:' \
		-i test/cases/secure_password_test.rb || die
}

each_ruby_test() {
	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true

	# TODO: needs running mysql instance
	#if use mysql; then
	#	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake test:mysql2
	#fi
	# TODO: needs running postgres instance
	#if use postgres; then
	#	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake test:postgresql
	#fi
	if use sqlite; then
		edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake test:sqlite3
	fi
}
