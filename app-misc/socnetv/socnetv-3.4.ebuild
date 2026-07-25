# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="https://socnetv.org/"
SRC_URI="https://github.com/socnetv/app/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/app-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,opengl,ssl,widgets,xml]
	dev-qt/qtcharts:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( AUTHORS CHANGELOG.md README.md TODO )

src_configure() {
	local mycmakeargs=(
		-DBUILD_CLI=$(usex test)
	)
	cmake_src_configure
}

src_test() {
	SOCNETV_CLI="${BUILD_DIR}"/socnetv-cli ./scripts/run_golden_compares.sh || die
}

src_install() {
	cmake_src_install
	rm -r "${ED}"/usr/share/doc/${PN} || die
}
