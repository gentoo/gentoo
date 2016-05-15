# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools bash-completion-r1 eutils toolchain-funcs

DESCRIPTION="IBM's tools for support of the ipr SCSI controller"
SRC_URI="mirror://sourceforge/iprdd/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/iprdd/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"
IUSE="static-libs"

IPRUTILS_DEPEND="
	>=sys-libs/ncurses-5.4-r5:=
	>=sys-apps/pciutils-2.1.11-r1
"
RDEPEND="
	${IPRUTILS_DEPEND}
	virtual/logger
	virtual/udev
"
DEPEND="
	${IPRUTILS_DEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.4.8-tinfo.patch \
		"${FILESDIR}"/${PN}-2.4.11.1-basename.patch \
		"${FILESDIR}"/${PN}-2.4.11.1-migrate_cand.patch

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install () {
	emake DESTDIR="${D}" \
		bashcompdir=$(get_bashcompdir) install

	newinitd "${FILESDIR}"/iprinit-r1 iprinit
	newinitd "${FILESDIR}"/iprupdate-r1 iprupdate
	newinitd "${FILESDIR}"/iprdump-r1 iprdump

	prune_libtool_files
}
