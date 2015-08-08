# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="OpenBSD fork of calmwm, a clean and lightweight window manager"
HOMEPAGE="http://www.openbsd.org/cgi-bin/cvsweb/xenocara/app/cwm/
	http://github.com/chneukirchen/cwm"
SRC_URI="vanilla? ( https://github.com/chneukirchen/cwm/tarball/0dec9e8 -> ${P}-chneukirchen.tar.gz )
	!vanilla? ( https://github.com/xmw/cwm/tarball/b8be675 -> ${P}-xmw.tar.gz )"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="vanilla"

RDEPEND="x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison"

src_unpack() {
	default
	# vcs-snapshot doesn't work with tarball names
	mv *-${PN}-* ${P} || die
}

src_compile() {
	emake CFLAGS="${CFLAGS} -D_GNU_SOURCE" CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README
	make_session_desktop ${PN} ${PN}
}
