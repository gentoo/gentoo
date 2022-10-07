# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,9,10} )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drmpeg/gr-paint.git"
else
	COMMIT="6cf1568eb9e32c25bf6414ad45f75048a5a2b74c"
	SRC_URI="https://github.com/drmpeg/gr-paint/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64"
fi
inherit cmake python-single-r1

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
		dev-libs/boost:=[python,${PYTHON_USEDEP}]
	')
	dev-libs/gmp
	sci-libs/volk:=
	sci-libs/fftw
	>=net-wireless/gnuradio-3.9:=[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep 'dev-python/pygccxml[${PYTHON_USEDEP}]')
"

RDEPEND="${DEPEND}"

BDEPEND="
	$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DOXYGEN=$(usex doc)
		-DPYTHON_EXECUTABLE="${PYTHON}"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.py[oc]' -delete || die
	python_optimize
	mv "${ED}/usr/share/doc/gr-paint" "${ED}/usr/share/doc/${P}"
}
