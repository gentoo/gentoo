# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmload/wmload-0.9.2.ebuild,v 1.13 2014/09/01 15:32:15 voyageur Exp $

EAPI=3
inherit eutils

IUSE=""

DESCRIPTION="yet another dock application showing a system load gauge"
SRC_URI="http://www.cs.mun.ca/~gstarkes/wmaker/dockapps/files/${P}.tgz"
HOMEPAGE="http://www.cs.mun.ca/~gstarkes/wmaker/dockapps/sys.html#wmload"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-misc/imake
	x11-proto/xproto
	x11-proto/xextproto"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ppc sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-ComplexProgramTargetNoMan.patch
	epatch "${FILESDIR}"/${PN}.solaris.patch
	epatch "${FILESDIR}"/${P}-prefix.patch
	[[ ${CHOST} == *-solaris* ]] && \
		sed -i -e 's/\(^XPMLIB = \)\(.*$\)/\1-lkstat \2/' Imakefile
}

src_configure() {
	xmkmf || die "xmkmf failed."
}

src_compile() {
	emake CDEBUGFLAGS="${CFLAGS}" LOCAL_LDFLAGS="${LDFLAGS}" \
		|| die "emake failed."
}

src_install() {
	emake DESTDIR="${D}" BINDIR="${EPREFIX}"/usr/bin install \
		|| die "install failed."

	dodoc README

	domenu "${FILESDIR}"/${PN}.desktop
}
