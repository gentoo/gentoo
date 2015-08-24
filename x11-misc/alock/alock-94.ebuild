# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils toolchain-funcs

DESCRIPTION="locks the local X display until a password is entered"
HOMEPAGE="https://code.google.com/p/alock/
	http://darkshed.net/projects/alock"
SRC_URI="https://alock.googlecode.com/files/alock-svn-${PV}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="imlib pam"

DEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libXrender
	x11-libs/libXcursor
	imlib? ( media-libs/imlib2[X] )
	pam? ( virtual/pam )"

S=${WORKDIR}/${PN}-svn-${PV}

src_prepare() {
	epatch "${FILESDIR}"/implicit_pointer_conversion_fix_amd64.patch
}

src_configure() {
	tc-export CC

	./configure \
		--prefix=/usr \
		--with-all \
		$(use_with pam) \
		$(use_with imlib imlib2) || die
}

src_compile() {
	emake XMLTO=true || die
}

src_install() {
	dobin src/alock || die
	doman alock.1 || die
	dodoc {CHANGELOG,README,TODO}.txt || die

	insinto /usr/share/alock/xcursors
	doins contrib/xcursor-* || die

	insinto /usr/share/alock/bitmaps
	doins bitmaps/* || die

	if ! use pam; then
		fperms 4755 /usr/bin/alock
	fi
}
