# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )

inherit autotools python-single-r1

DESCRIPTION="Scripts to prepare and plot VOACAP propagation predictions"
HOMEPAGE="https://www.qsl.net/h/hz1jw/pythonprop"
SRC_URI="https://github.com/jawatson/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
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

PATCHES=( "${FILESDIR}/${PN}-drop-portland.patch" )

src_prepare() {
	eapply_user

	eapply ${PATCHES[@]}

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
