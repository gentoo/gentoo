# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

DESCRIPTION="Capabilities for sorting and reordering a number of objects in a list"
HOMEPAGE="https://github.com/swanandp/acts_as_list"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activerecord-4.2:*"

ruby_add_bdepend "
	test? (
		dev-ruby/mocha
		dev-ruby/test-unit:2
		dev-ruby/timecop
		dev-ruby/activerecord[sqlite]
	)"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/bundler/,/^end/ s:^:#:' test/helper.rb || die
	sed -i -e '/git ls/d' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/github_changelog/,$ s:^:#:' Rakefile || die
}
