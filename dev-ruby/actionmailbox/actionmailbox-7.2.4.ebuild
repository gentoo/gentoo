# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="app config db"
RUBY_FAKEGEM_GEMSPEC="actionmailbox.gemspec"
RUBY_FAKEGEM_RECIPE_DOC="none"

inherit edo ruby-fakegem

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
		dev-ruby/minitest:5
		~dev-ruby/actionmailer-${PV}
		~dev-ruby/railties-${PV}
		>=dev-ruby/propshaft-0.1.7
		>=dev-ruby/sqlite3-1.6.6
		dev-ruby/thor
		dev-ruby/webmock
		dev-ruby/zeitwerk
	)
"

all_ruby_prepare() {
	# Replace Gemfile with something simpler for the test run
	cat <<-EOF > ../Gemfile || die
	source "https://rubygems.org"
	gemspec

	gem "rake"

	gem "minitest", "~> 5.0"

	gem "actionmailer", "${PV}"
	gem "railties", "${PV}"
	gem "propshaft", ">= 0.1.7"
	gem "sqlite3", ">= 1.6.6"
	gem "thor"
	gem "webmock"
	gem "zeitwerk"
	EOF
	rm ../Gemfile.lock || die

	# Don't pull in all of rails for tests. Handle it explicitly via Gemfile
	sed -E -e "/s.add_dependency/ { /(${PN}|bundler)/!d }" -i ../rails.gemspec || die
}

each_ruby_prepare() {
	sed -e 's:ruby:'${RUBY}':' -i test/dummy/bin/* || die
}

each_ruby_test() {
	# Allow the minitest rails plugin to be found.
	local -x  RUBYLIB=../railties/lib

	local -x BUNDLE_GEMFILE="../Gemfile"
	local -x MT_NO_PLUGINS=true
	edo ${RUBY} -S bundle exec ${RUBY} --disable=did_you_mean -S rake
}
