# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

inherit ruby-fakegem

DESCRIPTION="Ruby CSS parser that's fully compliant with the CSS Syntax Level 3 specification"
HOMEPAGE="https://github.com/rgrove/crass/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc ~ppc64 ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend ">=dev-ruby/minitest-5.0.8:5"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
}
