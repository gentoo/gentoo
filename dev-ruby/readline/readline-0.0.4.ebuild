# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="readline.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="none"

inherit ruby-fakegem

DESCRIPTION="Class to build custom data structures, similar to a Hash"
HOMEPAGE="https://github.com/ruby/readline"
SRC_URI="https://github.com/ruby/readline/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

all_ruby_prepare() {
	sed -e 's/__FILE__/"readline.gemspec"/' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
