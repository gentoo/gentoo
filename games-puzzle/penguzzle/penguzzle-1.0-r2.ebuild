# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="Tcl/Tk variant of the well-known 15-puzzle game"
HOMEPAGE="http://www.naskita.com/linux/penguzzle/penguzzle.shtml"
SRC_URI="http://www.naskita.com/linux/${PN}/${PN}.zip -> ${P}.zip"

LICENSE="penguzzle"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/tk:0=
	dev-tcltk/tclx"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}${PV}"

src_prepare() {
	default
	sed -i \
		-e "s:~/puzz/images:/usr/share/${PN}:" \
		lib/init \
		|| die "sed init failed"
	sed -i \
		-e "s:~/puzz/lib:/usr/$(get_libdir)/${PN}:" \
		bin/${PN} \
		|| die "sed ${PN} failed"

	eapply "${FILESDIR}"/${P}-tclx.patch
}

src_install() {
	dobin bin/${PN}

	insinto /usr/share/${PN}
	doins images/img0.gif

	insinto /usr/$(get_libdir)/${PN}
	doins lib/init

	newicon images/img0.gif ${PN}.gif
	make_desktop_entry ${PN} "Penguzzle" /usr/share/pixmaps/${PN}.gif

	einstalldocs
}
