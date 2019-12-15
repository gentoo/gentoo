# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs git-r3

DESCRIPTION="OpenBSD fork of calmwm, a clean and lightweight window manager"
HOMEPAGE="https://www.openbsd.org/cgi-bin/cvsweb/xenocara/app/cwm/
	https://github.com/chneukirchen/cwm"
EGIT_BRANCH=linux

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="vanilla"

RDEPEND="x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/bison"

pkg_setup() {
	if use vanilla ; then
		EGIT_REPO_URI="https://github.com/chneukirchen/cwm.git"
	else
		EGIT_REPO_URI="https://github.com/xmw/cwm.git"
	fi
}

src_compile() {
	emake CFLAGS="${CFLAGS} -D_GNU_SOURCE" CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install
	dodoc README
	make_session_desktop ${PN} ${PN}
}
