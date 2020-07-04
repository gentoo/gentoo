# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit desktop python-r1

MY_PV="${PV//./}"
MY_P="${PN}_b${MY_PV}"

DESCRIPTION="A traditional and challenging 2D platformer game with a slight rotational twist"
HOMEPAGE="http://hectigo.net/puskutraktori/whichwayisup/"
SRC_URI="http://hectigo.net/puskutraktori/whichwayisup/${MY_P}.zip"

LICENSE="GPL-2 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${PN}"

PATCHES=(
	# Fixes from Fedora
	"${FILESDIR}"/${P}-check_for_joystick_axes_not_null.patch
	"${FILESDIR}"/${P}-initialize_only_required_pygame_modules.patch
	"${FILESDIR}"/${P}-python3.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:libdir\ =\ .*:libdir\ =\ \"/usr/$(get_libdir)/${PN}\":" \
		run_game.py || die
	sed -i \
		-e "s:data_dir\ =\ .*:data_dir\ =\ \"/usr/share/${PN}\":" \
		lib/data.py || die
	rm data/pictures/Thumbs.db || die
}

src_install() {
	newbin run_game.py ${PN}

	insinto "/usr/$(get_libdir)/${PN}"
	doins lib/*.py

	einstalldocs

	insinto "/usr/share/${PN}"
	doins -r data/*

	newicon "${FILESDIR}"/${PN}-32.xpm ${PN}.xpm
	make_desktop_entry ${PN} "Which Way Is Up?"
}
