# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop eutils gnome2-utils python-single-r1 xdg

DESCRIPTION="A side scrolling shooter game starring a steamboat on the sea"
HOMEPAGE="http://funnyboat.sourceforge.net/"
SRC_URI="
	mirror://sourceforge/${PN}/${P/_p*}-src.zip
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}-${PV/*_p}.debian.tar.xz
"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/pygame-1.6.2[${PYTHON_USEDEP}]
"
DEPEND="${DEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

src_prepare() {
	# Drop Debian specific patch
	rm "${WORKDIR}"/debian/patches/use_debian_vera_ttf.patch || die
	eapply -p1 "${WORKDIR}"/debian/patches/*.patch

	xdg_src_prepare
}

src_install() {
	insinto /usr/share/${PN}
	doins -r data *.py
	python_optimize "${ED}"/usr/share/${PN}

	dodoc *.txt

	make_wrapper ${PN} "${EPYTHON} main.py" /usr/share/${PN}

	newicon data/titanic.png ${PN}.png
	make_desktop_entry ${PN} "Trip on the Funny Boat"
}
