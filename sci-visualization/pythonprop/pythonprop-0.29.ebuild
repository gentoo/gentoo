# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )

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
		dev-python/matplotlib[${PYTHON_MULTI_USEDEP}]
		sci-libs/cartopy[${PYTHON_MULTI_USEDEP}]
	')
	dev-python/cairocffi
	sci-electronics/voacapl
"
DEPEND="${RDEPEND}
	app-text/gnome-doc-utils
	app-text/rarian
"

src_prepare() {
	eapply_user

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
