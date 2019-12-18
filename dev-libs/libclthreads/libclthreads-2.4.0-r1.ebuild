# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib toolchain-funcs

MY_P="${P/lib/}"

S="${WORKDIR}/${MY_P}"

DESCRIPTION="POSIX threads C++ access library"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.4.0-Makefile.patch"
}

src_compile() {
	tc-export CC CXX
	emake
}

src_install() {
	emake CLTHREADS_LIBDIR="/usr/$(get_libdir)" DESTDIR="${ED}" install
	dodoc AUTHORS
}
