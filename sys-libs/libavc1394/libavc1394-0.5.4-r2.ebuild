# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal

DESCRIPTION="Library for the 1394 AV/C (Audio/Video Control) Digital Interface Command Set"
HOMEPAGE="https://sourceforge.net/projects/libavc1394/"
SRC_URI="mirror://sourceforge/libavc1394/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"

BDEPEND="virtual/pkgconfig"
DEPEND=">=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]
	elibc_musl? ( sys-libs/argp-standalone )"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	# bug #713174
	use elibc_musl && append-libs -largp

	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
