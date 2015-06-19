# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/aeolus/aeolus-0.8.4.ebuild,v 1.2 2015/03/18 10:00:45 aballier Exp $

inherit versionator toolchain-funcs multilib

MY_P=${PN}-$(replace_version_separator 3 '-')

DESCRIPTION="A synthesised pipe organ emulator"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/aeolus/index.html"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-libs/libclalsadrv-2.0.0
	>=media-libs/libclthreads-2.4.0
	>=media-libs/libclxclient-3.6.1
	x11-libs/libXft
	x11-libs/libX11
	>=media-sound/jack-audio-connection-kit-0.109.2
	media-libs/alsa-lib
	sys-libs/readline"

RDEPEND="${DEPEND}
	media-libs/stops"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)/source

src_compile() {
	tc-export CXX
	sed -i -e "s/-O3//" Makefile || die "Failed to remove forced CFLAGS"
	sed -i -e "s:/sbin/ldconfig:true:" Makefile || die "Failed to remove ldconfig call CFLAGS"
	sed -i -e "s/g++/$(tc-getCXX)/" Makefile || die "Failed to set correct compiler"
	emake PREFIX="/usr" LIBDIR=$(get_libdir) || die "make failed"
}

src_install() {
	emake PREFIX="${D}/usr" install || die "make install failed"
	dodoc ../README ../AUTHORS
	echo "-S /usr/share/stops" > "${T}/aeolus.conf"
	insinto /etc
	doins "${T}/aeolus.conf"
}
