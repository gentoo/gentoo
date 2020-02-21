# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic libtool linux-info ltprune

DESCRIPTION="Tools for ATM"
HOMEPAGE="http://linux-atm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE="static-libs"

RDEPEND=""
DEPEND="virtual/yacc"

RESTRICT="test"

DOCS=( AUTHORS BUGS ChangeLog NEWS README THANKS )

CONFIG_CHECK="~ATM"

src_prepare() {
	epatch "${FILESDIR}"/${P}-headers.patch
	epatch "${FILESDIR}"/${P}-linux-5.2-SIOCGSTAMP.patch

	sed -i '/#define _LINUX_NETDEVICE_H/d' \
		src/arpd/*.c || die "sed command on arpd/*.c files failed"

	elibtoolize
}

src_configure() {
	append-flags -fno-strict-aliasing

	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
	dodoc doc/README* doc/atm*
}
