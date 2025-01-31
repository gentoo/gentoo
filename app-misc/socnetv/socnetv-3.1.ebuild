# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Qt Social Network Visualizer"
HOMEPAGE="https://socnetv.org/"
SRC_URI="https://github.com/socnetv/app/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/app-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,network,opengl,widgets]
	dev-qt/qtcharts:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=( "${FILESDIR}"/${PN}-3.1-deps.patch )

src_configure() {
	$(qt6_get_bindir)/lrelease socnetv.pro || die "lrelease failed"
	eqmake6 socnetv.pro
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
}
