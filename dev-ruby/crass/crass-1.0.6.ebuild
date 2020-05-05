# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="HISTORY.md README.md"

RUBY_FAKEGEM_GEMSPEC="crass.gemspec"

inherit ruby-fakegem

DESCRIPTION="Ruby CSS parser that's fully compliant with the CSS Syntax Level 3 specification"
HOMEPAGE="https://github.com/rgrove/crass/"
SRC_URI="https://github.com/rgrove/crass/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend ">=dev-ruby/minitest-5.0.8:5"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
	sed -i -e 's/git ls-files -z/find -print0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}
