# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="red-blue Quake II !  play quake2 w/3d glasses !"
HOMEPAGE="http://www.jfedor.org/red-blue-quake2/"
SRC_URI="mirror://idsoftware/source/q2source-3.21.zip
	http://www.jfedor.org/red-blue-quake2/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/quake2-3.21/linux

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}/${P}"-gcc41.patch \
		"${FILESDIR}/${P}"-ldflags.patch
	sed -i \
		-e "s:GENTOO_DIR:$(games_get_libdir)/${PN}:" \
		sys_linux.c || die
	sed -i \
		-e "s:/etc/quake2.conf:${GAMES_SYSCONFDIR}/${PN}.conf:" \
		sys_linux.c vid_so.c || die
	echo "$(games_get_libdir)"/${PN} > "${T}"/${PN}.conf || die
}

src_compile() {
	mkdir -p releasei386-glibc/ref_soft
	emake \
		GENTOO_CFLAGS="${CFLAGS}" \
		GENTOO_DATADIR="${GAMES_DATADIR}"/quake2/baseq2/ \
		build_release
}

src_install() {
	cd release*

	exeinto "$(games_get_libdir)"/${PN}
	doexe gamei386.so ref_softx.so
	exeinto "$(games_get_libdir)"/${PN}/ctf
	doexe ctf/gamei386.so
	newgamesbin quake2 red-blue-quake2

	insinto "${GAMES_SYSCONFDIR}"
	doins "${T}"/${PN}.conf

	prepgamesdirs
}
