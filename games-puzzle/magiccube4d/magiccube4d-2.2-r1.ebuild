# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

MY_PV="${PV/./_}"
DESCRIPTION="Four-dimensional analog of Rubik's cube"
HOMEPAGE="http://www.superliminal.com/cube/cube.htm"
SRC_URI="http://www.superliminal.com/cube/mc4d-src-${MY_PV}.tgz
	http://superliminal.com/cube/cube_transp.gif -> ${PN}.gif"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/libXaw"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-src-${MY_PV}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${PN}-EventHandler.patch \
		"${FILESDIR}/${P}"-gcc41.patch \
		"${FILESDIR}/${P}"-64bit-ptr.patch \
		"${FILESDIR}"/${P}-ldflags.patch
	sed -i \
		-e "s:-Werror::" \
		configure \
		|| die "sed failed"
}

src_compile() {
	emake DFLAGS="${CFLAGS}"
}

src_install() {
	dobin magiccube4d
	dodoc ChangeLog MagicCube4D-unix.txt readme-unix.txt Intro.txt
	doicon "${DISTDIR}"/${PN}.gif
	make_desktop_entry ${PN} "Magic Cube 4D" /usr/share/pixmaps/${PN}.gif
}
