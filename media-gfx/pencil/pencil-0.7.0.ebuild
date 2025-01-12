# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils xdg

DESCRIPTION="2D animation and drawing program based on Qt"
HOMEPAGE="https://www.pencil2d.org/"
SRC_URI="https://github.com/pencil2d/${PN}/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qtmultimedia:6
	dev-qt/qtsvg:6
"
DEPEND="${RDEPEND}"
# BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
# 	$(qt6_get_bindir)/lrelease gpxsee.pro || die
	eqmake6 PREFIX=/usr $(usex test "" "CONFIG+=NO_TESTS")
}

src_install() {
	einstalldocs
	emake INSTALL_ROOT="${D}" install
	# TODO: Install l10n files
}
