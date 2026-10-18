# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.rdoc"
RUBY_FAKEGEM_EXTRAINSTALL="app"
RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit edo ruby-fakegem

DESCRIPTION="Simple, battle-tested conventions and helpers for building web pages"
HOMEPAGE="https://github.com/rails/rails/"

SRC_URI="https://github.com/rails/rails/archive/v${PV}.tar.gz -> rails-${PV}.tgz"
RUBY_S="rails-${PV}/${PN}"

LICENSE="MIT"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

ruby_add_rdepend "
	~dev-ruby/activesupport-${PV}
	>=dev-ruby/builder-3.1:* =dev-ruby/builder-3*:*
	>=dev-ruby/erubi-1.11:0
	>=dev-ruby/rails-dom-testing-2.2:2
	>=dev-ruby/rails-html-sanitizer-1.6:1
"

ruby_add_bdepend "
	test? (
		~dev-ruby/actionpack-${PV}
		~dev-ruby/activemodel-${PV}
		~dev-ruby/activerecord-${PV}
		>=dev-ruby/capybara-3.39
		dev-ruby/minitest:5
		>=dev-ruby/sqlite3-1.6.6
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 5.0"

	gem "actionpack", "${PV}"
	gem "activemodel", "${PV}"
	gem "activerecord", "${PV}"
	gem "capybara", ">= 3.39"
	gem "sqlite3", ">= 1.6.6"
	EOF
	rm ../Gemfile.lock || die
}

each_ruby_test() {
	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake
}
