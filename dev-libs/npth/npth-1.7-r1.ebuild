# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="New GNU Portable Threads Library"
HOMEPAGE="https://git.gnupg.org/cgi-bin/gitweb.cgi?p=npth.git"
SRC_URI="mirror://gnupg/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	econf $(use_enable test tests) \
		--enable-install-npth-config
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
