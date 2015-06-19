# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/scsh/scsh-0.6.7-r1.ebuild,v 1.2 2012/11/24 14:16:37 ulm Exp $

EAPI="2"

inherit eutils multilib

MY_PV="${PV%*.*}"

DESCRIPTION="Unix shell embedded in Scheme"
HOMEPAGE="http://www.scsh.net/"
SRC_URI="ftp://ftp.scsh.net/pub/scsh/${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="!dev-scheme/scheme48"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-Makefile.in-doc-dir-gentoo.patch"
	epatch "${FILESDIR}/${PV}-Makefile.in-LDFLAGS.patch"
	epatch "${FILESDIR}/${PV}-Missing-includes.patch"
}

src_configure() {
	use amd64 && multilib_toolchain_setup x86
	SCSH_LIB_DIRS="/usr/$(get_libdir)/${PN}"
	econf \
		--libdir=/usr/$(get_libdir) \
		--includedir=/usr/include \
		--with-lib-dirs-list=${SCSH_LIB_DIRS}
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die "make install failed."

	local ENVD="${T}/50scsh"
	echo "SCSH_LIB_DIRS=\"${SCSH_LIB_DIRS}\"" > "${ENVD}"
	doenvd "${ENVD}"
}
