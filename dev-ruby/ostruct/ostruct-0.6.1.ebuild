# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINWRAP=""
RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_GEMSPEC="ostruct.gemspec"

inherit ruby-fakegem

DESCRIPTION="Class to build custom data structures, similar to a Hash"
HOMEPAGE="https://github.com/ruby/ostruct"
SRC_URI="https://github.com/ruby/ostruct/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="test"

ruby_add_depend "test? ( dev-ruby/test-unit dev-ruby/test-unit-ruby-core )"

all_ruby_prepare() {
	sed -e 's/__FILE__/"ostruct.gemspec"/' \
		-e 's/__dir__/"."/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}
