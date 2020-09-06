# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_SINGLE_IMPL=1

inherit desktop distutils-r1 xdg

DESCRIPTION="Fast and easy graphics application for digital painters"
HOMEPAGE="http://mypaint.org/"
SRC_URI="https://github.com/mypaint/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LANGS="cs de en_CA en_GB es fr hu id it ja ko nb nn_NO pl pt_BR ro ru sl sv uk zh_CN zh_TW"

BDEPEND="
	${PYTHON_DEPS}
	dev-lang/swig
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/pycairo-1.4[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
	')
	>=dev-libs/json-c-0.11:=
	gnome-base/librsvg
	media-gfx/mypaint-brushes:2.0
	media-libs/lcms:2
	>=media-libs/libmypaint-1.5.0
	media-libs/libpng:0=
	sys-devel/gettext
	sys-libs/libomp
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.0.1-build-system.patch"
)

distutils_enable_tests setup.py

# TODO: Allow openmp support (patched out)
# There's no urgency on this given that it currently
# breaks runtime use [0]
# [0] https://github.com/mypaint/mypaint/issues/1107.

src_install() {
	distutils-r1_src_install

	newicon pixmaps/${PN}_logo.png ${PN}.png

	local lang=
	for lang in ${LANGS}; do
		if ! has ${lang} ${LINGUAS}; then
			rm -rf "${ED}"/usr/share/locale/${lang} || die
		fi
	done
}
