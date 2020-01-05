# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DISTUTILS_IN_SOURCE_BUILD=1

DESCRIPTION="Library for rapid development of hardware-accelerated multitouch applications"
HOMEPAGE="https://kivy.org/"
SRC_URI="https://github.com/kivy/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="cairo doc examples garden gstreamer +sdl spell test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/mesa[gles2]
	dev-python/pillow[${PYTHON_USEDEP}]
	cairo? ( dev-python/pycairo[${PYTHON_USEDEP}] )
	garden? ( dev-python/kivy-garden[${PYTHON_USEDEP}] )
	gstreamer? ( dev-python/gst-python:1.0[${PYTHON_USEDEP}] )
	sdl? ( media-libs/libsdl2
		media-libs/sdl2-ttf
		media-libs/sdl2-image
		media-libs/sdl2-mixer )
	!sdl? ( dev-python/pygame[${PYTHON_USEDEP}] )
	spell? ( dev-python/pyenchant[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${P,,}"

python_prepare_all() {
# 	sed -e '/data_files=/d' -i "${S}/setup.py" || die
# 	sed -e 's/PYTHON = python/PYTHON ?= python/' -i Makefile || die

	export USE_SDL2=$(usex sdl 1 0)
	export USE_GSTREAMER=$(usex gstreamer 1 0)
	export KIVY_USE_SETUPTOOLS=1
	distutils-r1_python_prepare_all
}

python_compile() {
	esetup.py build_ext --inplace
	esetup.py build
}

python_compile_all() {
	use doc && emake html
}

python_test() {
	emake test PYTHON="${PYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )
	if use examples; then
		insinto "/usr/share/doc/${PF}/examples/${f}/"
		doins "${S}/examples"/* "${S}/examples"/*/*
	fi
	distutils-r1_python_install_all
}
