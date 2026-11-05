# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/drmpeg/gr-paint.git"
else
	COMMIT="c443e36e8ab22ea7819db28df7b69378027dd5b5"
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

RDEPEND="${PYTHON_DEPS}
	sci-libs/volk:=
	>=net-wireless/gnuradio-3.9:=[${PYTHON_SINGLE_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
	')
"
DEPEND="${RDEPEND}
	dev-libs/boost:=
	dev-libs/gmp
	dev-libs/spdlog
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
	virtual/pkgconfig
	doc? ( app-text/doxygen )
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
	if use doc; then
		mv "${ED}"/usr/share/doc/${PN}/* "${ED}"/usr/share/doc/${PF}/ || die
		rmdir "${ED}"/usr/share/doc/${PN} || die
	fi
}
