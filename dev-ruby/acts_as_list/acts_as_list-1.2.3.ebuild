# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

inherit ruby-fakegem

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_EXTRAINSTALL="init.rb"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

DESCRIPTION="Capabilities for sorting and reordering a number of objects in a list"
HOMEPAGE="https://github.com/brendon/acts_as_list"
SRC_URI="https://github.com/brendon/acts_as_list/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/activerecord-6.1:* >=dev-ruby/activesupport-6.1:*"

ruby_add_bdepend "
	test? (
		>=dev-ruby/minitest-hooks-1.5.1:1
		>=dev-ruby/mocha-2.1.0:2
		dev-ruby/test-unit:2
		>=dev-ruby/timecop-0.9.8
		dev-ruby/activerecord[sqlite]
	)"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile || die
	sed -i -e '/bundler/,/^end/ s:^:#:' test/helper.rb || die
	sed -e 's/git ls-files -z/find lib CHANGELOG.md README.md init.rb -print0/' \
		-e '/executables/ s:^:#:' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
	sed -i -e '/github_changelog/,$ s:^:#:' Rakefile || die
}

each_ruby_test() {
	DB=sqlite each_fakegem_test
}
