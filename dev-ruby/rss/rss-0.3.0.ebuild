# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"
RUBY_FAKEGEM_GEMSPEC="rss.gemspec"

inherit ruby-fakegem

DESCRIPTION="Family of libraries that support various formats of XML feeds"
HOMEPAGE="https://github.com/ruby/rss"
SRC_URI="https://github.com/ruby/rss/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
SLOT="0"
IUSE="test"

ruby_add_rdepend "dev-ruby/rexml"

ruby_add_bdepend "test? ( dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -i -e '/bundler/,/^helper.install/ s:^:#:' Rakefile || die

	sed -i -e 's:_relative ": "./:' ${RUBY_FAKEGEM_GEMSPEC} || die
}
