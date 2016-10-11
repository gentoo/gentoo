# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
	local installdir

	epatch "${FILESDIR}/${PN}-11.0-gentoo.patch"
	epatch "${FILESDIR}/${PN}-11.0-rename-libs.patch"
	epatch "${FILESDIR}/${PN}-11.0-libproc-libcxx.patch"
	epatch "${FILESDIR}/${PN}-11.0-drop-unsupport-cflags.patch"
	use userland_GNU && epatch "${FILESDIR}/${PN}-11.0-gnu.patch"

	if [[ ${CHOST} != *-freebsd* ]]; then
		installdir="/usr/share/mk/freebsd"
	else
		installdir="/usr/share/mk"
	fi

	sed -i -e "s:FILESDIR=.*:FILESDIR= ${installdir}:" "${S}"/Makefile || die
}

src_compile() { :; }

src_install() {
	freebsd_src_install
	if [[ ${CHOST} != *-freebsd* ]]; then
		insinto /usr/share/mk/freebsd/system
	else
		insinto /usr/share/mk/system
	fi
	doins *.mk *.awk
}
