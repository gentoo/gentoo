# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils toolchain-funcs

DESCRIPTION="IBM's tools for support of the ipr SCSI controller"
SRC_URI="mirror://sourceforge/iprdd/${P}.tar.gz"
HOMEPAGE="https://sourceforge.net/projects/iprdd/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="ppc ppc64"
IUSE="static-libs"

DEPEND="
	>=sys-libs/ncurses-5.4-r5
	>=sys-apps/pciutils-2.1.11-r1
	virtual/udev
"
RDEPEND="
	${DEPEND}
	virtual/logger
"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.4.7-tinfo.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install () {
	default

	newinitd "${FILESDIR}"/iprinit-r1 iprinit
	newinitd "${FILESDIR}"/iprupdate-r1 iprupdate
	newinitd "${FILESDIR}"/iprdump-r1 iprdump

	prune_libtool_files
}
