# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ssh-askpass-fullscreen/ssh-askpass-fullscreen-1.0-r1.ebuild,v 1.11 2015/04/02 18:53:43 mr_bones_ Exp $

EAPI=4

inherit autotools eutils

DESCRIPTION="A small SSH Askpass replacement written with GTK2"
HOMEPAGE="https://github.com/atj/ssh-askpass-fullscreen"
SRC_URI="mirror://github/atj/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.10.0:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# https://github.com/atj/ssh-askpass-fullscreen/pull/1
	epatch "${FILESDIR}/${P}-libX11.patch"

	# automake-1.13 fix, bug #468764
	sed -i -e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' configure.ac || die

	eautoreconf
}

src_install() {
	default
	# Automatically display the passphrase dialog - see bug #437764
	echo "SSH_ASKPASS='${EPREFIX}/usr/bin/ssh-askpass-fullscreen'" >> "${T}/99ssh_askpass" \
		|| die "envd file creation failed"
	doenvd "${T}"/99ssh_askpass || die "doenvd failed"
}
