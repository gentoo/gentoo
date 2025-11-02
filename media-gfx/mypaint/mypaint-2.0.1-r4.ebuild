# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

inherit desktop edo python-single-r1 toolchain-funcs xdg

DESCRIPTION="Fast and easy graphics application for digital painters"
HOMEPAGE="https://www.mypaint.app/en/"
SRC_URI="https://github.com/mypaint/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="openmp"
LANGS="cs de en_CA en_GB es fr hu id it ja ko nb nn_NO pl pt_BR ro ru sl sv uk zh_CN zh_TW"
# Relies on setup.py test (long-removed) and nose (also long-removed)
# See bug #927525 and https://github.com/mypaint/mypaint/issues/1191
RESTRICT="test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		>=dev-python/pycairo-1.4[${PYTHON_USEDEP}]
		dev-python/protobuf[${PYTHON_USEDEP}]
	')
	>=dev-libs/json-c-0.11:=
	gnome-base/librsvg
	media-gfx/mypaint-brushes:2.0
	media-libs/lcms:2
	>=media-libs/libmypaint-1.5.0[openmp?]
	media-libs/libpng:=
	sys-devel/gettext
	llvm-runtimes/openmp
	x11-libs/gdk-pixbuf[jpeg]
	x11-libs/gtk+:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_USEDEP}]
	')
	dev-lang/swig
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.0.1-r1-build-system.patch
	"${FILESDIR}"/${P}-GIL-hold.patch
	"${FILESDIR}"/${P}-setuptools.patch
	"${FILESDIR}"/${PN}-2.0.1-python3.11.patch
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	python-single-r1_pkg_setup
}

src_compile() {
	# --disable-openmp can't be passed to setup.py build,
	# only setup.py build_ext.
	# Trying to call build_ext then build and such fails.
	#
	# We just override the environment instead for simplicity.
	local openmp=$(usex openmp '-fopenmp' '-fno-openmp')

	local -x OPENMP_CFLAG="${openmp}" OPENMP_LDFLAG="${openmp}"
	edo ${EPYTHON} setup.py build
}

src_install() {
	edo ${EPYTHON} setup.py install --prefix="${EPREFIX}/usr" --root="${D}"
	python_fix_shebang "${ED}"/usr/bin
	python_optimize
	python_optimize "${ED}/usr/lib/mypaint"
	einstalldocs

	newicon pixmaps/${PN}_logo.png ${PN}.png

	local lang=
	for lang in ${LANGS}; do
		if ! has ${lang} ${LINGUAS}; then
			rm -rf "${ED}"/usr/share/locale/${lang} || die
		fi
	done
}
