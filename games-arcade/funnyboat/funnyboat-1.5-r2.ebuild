# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit desktop eutils gnome2-utils python-single-r1

DESCRIPTION="A side scrolling shooter game starring a steamboat on the sea"
HOMEPAGE="http://funnyboat.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	>=dev-python/pygame-1.6.2[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

src_install() {
	insinto /usr/share/${PN}
	doins -r data *.py
	python_optimize "${ED%/}"/usr/share/${PN}

	dodoc *.txt

	make_wrapper ${PN} "${EPYTHON} main.py" /usr/share/${PN}

	newicon -s 32 data/kuvake.png ${PN}.png
	make_desktop_entry ${PN} "Trip on the Funny Boat"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
