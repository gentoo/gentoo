# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drmpeg/gr-paint38.git"
else
	COMMIT="9cb4eabe3b570ccd1f53837681607d73501b5c1e"
	SRC_URI="https://github.com/drmpeg/gr-paint38/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}38-${COMMIT}"
	KEYWORDS="~amd64"
fi
inherit cmake-utils python-single-r1

DESCRIPTION="Paints monochrome images into the waterfall of a receiver"
HOMEPAGE="https://github.com/drmpeg/gr-paint"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"
#< drmpeg> What tests?
RESTRICT="test"

DEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-libs/boost:=[${PYTHON_MULTI_USEDEP}]
	')
	dev-libs/gmp
	sci-libs/volk
	=net-wireless/gnuradio-3.8*:=[${PYTHON_SINGLE_USEDEP}]
"
RDEPEND="${DEPEND}
	media-gfx/imagemagick
"
BDEPEND="
	dev-lang/swig
	dev-util/cppunit
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOXYGEN=$(usex doc)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	python_optimize
}
