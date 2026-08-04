# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app db package.json"
RUBY_FAKEGEM_GEMSPEC="actiontext.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit ruby-fakegem

DESCRIPTION="Edit and display rich text in Rails applications"
HOMEPAGE="https://github.com/rails/rails"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"

ruby_add_rdepend "
	~dev-ruby/actionpack-${PV}
	>=dev-ruby/action_text-trix-2.1.15:2
	~dev-ruby/activerecord-${PV}
	~dev-ruby/activestorage-${PV}
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/globalid-0.6.0
	>=dev-ruby/nokogiri-1.8.5
"

ruby_add_bdepend "
	test? (
		dev-ruby/bundler
		>=dev-ruby/importmap-rails-1.2.3
		dev-ruby/minitest:6
		dev-ruby/minitest-mock
		>=dev-ruby/propshaft-0.1.7
		>=dev-ruby/sqlite3-2.1
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

	gem "importmap-rails", ">= 1.2.3"
	gem "propshaft", ">= 0.1.7"
	gem "sqlite3", ">= 2.1"
	EOF
	rm ../Gemfile.lock || die

	# Avoid failing test depending on yarn
	rm -f test/javascript_package_test.rb || die
}

each_ruby_prepare() {
	sed -i -e 's:ruby:'${RUBY}':' test/dummy/bin/* || die
}

each_ruby_test() {
	local -x SEED="2"
	each_fakegem_test
}
