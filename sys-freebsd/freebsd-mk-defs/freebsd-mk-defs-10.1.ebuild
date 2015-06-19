# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-freebsd/freebsd-mk-defs/freebsd-mk-defs-10.1.ebuild,v 1.3 2015/06/05 16:43:55 mgorny Exp $

EAPI=5

inherit bsdmk freebsd

DESCRIPTION="Makefiles definitions used for building and installing libraries and system files"
SLOT="0"

IUSE="userland_GNU"

if [[ ${PV} != *9999* ]]; then
	KEYWORDS="~amd64 ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
fi

EXTRACTONLY="share/"

RDEPEND=""
DEPEND=""

RESTRICT="strip"

S="${WORKDIR}/share/mk"

src_prepare() {
	epatch "${FILESDIR}/${PN}-10.0-gentoo.patch"
	epatch "${FILESDIR}/${PN}-add-nossp-cflags.patch"
	use userland_GNU && epatch "${FILESDIR}/${PN}-10.1-gnu.patch"
}

src_compile() { :; }

src_install() {
	if [[ ${CHOST} != *-freebsd* ]]; then
		insinto /usr/share/mk/freebsd
	else
		insinto /usr/share/mk
	fi
	doins *.mk *.awk
}
