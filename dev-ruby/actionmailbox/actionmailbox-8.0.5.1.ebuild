# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app config db"
RUBY_FAKEGEM_GEMSPEC="actionmailbox.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Framework for designing email-service layers"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	~dev-ruby/activejob-${PV}
	~dev-ruby/activerecord-${PV}
	~dev-ruby/activestorage-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/mail-2.8.0:*
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
		>=dev-ruby/propshaft-0.1.7
		>=dev-ruby/sqlite3-2.1
		dev-ruby/webmock
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

	gem "propshaft", ">= 0.1.7"
	gem "sqlite3", ">= 2.1"
	gem "webmock"
	EOF
	rm ../Gemfile.lock || die
}

each_ruby_prepare() {
	sed -e 's:ruby:'${RUBY}':' -i test/dummy/bin/* || die
}
