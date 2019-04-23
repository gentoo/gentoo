# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit flag-o-matic gnome2-utils scons-utils toolchain-funcs python-single-r1 xdg

DESCRIPTION="fast and easy graphics application for digital painters"
HOMEPAGE="http://mypaint.org/"
SRC_URI="https://github.com/mypaint/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

LANGS="cs de en_CA en_GB es fr hu id it ja ko nb nn_NO pl pt_BR ro ru sl sv uk zh_CN zh_TW"

RDEPEND="${PYTHON_DEPS}
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.4[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	>=dev-libs/json-c-0.11:=
	media-libs/lcms:2
	>=media-libs/libmypaint-1.3.0
	media-libs/libpng:0=
	gnome-base/librsvg
	sys-libs/libomp
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}
	dev-lang/swig
	virtual/pkgconfig
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_compile() {
	# Workaround scons bug with locales. Bug #352700
	export LANG="en_US.UTF-8"
	tc-export CC CXX
	strip-flags  # scons upstream issue #3017
	escons
}

src_install () {
	escons prefix="${D}/usr" install
	newicon pixmaps/${PN}_logo.png ${PN}.png
	for x in ${LANGS}; do
		if ! has ${x} ${LINGUAS}; then
			rm -rf "${ED}"/usr/share/locale/${x} || die
		fi
	done

	python_optimize "${D}"usr/share/${PN}
	# not used and broken
	rm -r "${ED}"/usr/{include/,lib/libmypaint.a,lib/pkgconfig/} || die
	# already provided by system-libmypaint
	rm "${ED}"/usr/share/locale/*/LC_MESSAGES/libmypaint* || die
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_pkg_postrm
	fdo-mime_desktop_database_update
}
