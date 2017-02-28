# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

DESCRIPTION="Capabilities for sorting and reordering a number of objects in a list"
HOMEPAGE="https://github.com/swanandp/acts_as_list"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64 ~x86-macos"
IUSE=""

ruby_add_rdepend ">=dev-ruby/activerecord-3:*"

ruby_add_bdepend "
	test? (
		dev-ruby/test-unit:2
		dev-ruby/activerecord[sqlite]
	)"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/bundler/,/^end/ s:^:#:' test/helper.rb || die
	sed -i -e '/git ls/d' ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/github_changelog/,$ s:^:#:' Rakefile || die
}
