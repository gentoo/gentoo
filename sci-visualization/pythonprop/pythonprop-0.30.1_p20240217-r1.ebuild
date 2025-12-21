# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )

inherit autotools python-single-r1

MY_PV=$(ver_cut 1-3)

DESCRIPTION="Scripts to prepare and plot VOACAP propagation predictions"
HOMEPAGE="https://www.qsl.net/h/hz1jw/pythonprop"
SRC_URI="https://github.com/jawatson/${PN}/archive/v${MY_PV}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	')
	dev-python/cairocffi
	sci-libs/cartopy[${PYTHON_SINGLE_USEDEP}]
	sci-electronics/voacapl
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
"

PATCHES=( "${FILESDIR}/${PN}-0.30.1-p20240217.patch"
		"${FILESDIR}/${PN}-matplotlib3.9.patch" )

src_prepare() {
	default

	# drop building *.pdf files
	sed -i -e "s#docs/user/help##g" Makefile.am || die
	# do not call update_destop_database here
	sed -ie "s/UPDATE_DESKTOP = /UPDATE_DESKTOP = # /g" data/Makefile.am || die
	# fix Desktop Entry
	sed -ie "s/HamRadio/HamRadio;/g" data/voacapgui.desktop.in || die
	eautoreconf
}

src_install() {
	default
	python_optimize
}
