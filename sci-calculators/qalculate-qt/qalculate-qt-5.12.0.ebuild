# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Bump with sci-libs/libqalculate and sci-calculators/qalculate-gtk!

inherit optfeature qmake-utils xdg

DESCRIPTION="Qt-based UI for libqalculate"
HOMEPAGE="https://github.com/Qalculate/qalculate-qt"
SRC_URI="https://github.com/Qalculate/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	>=sci-libs/libqalculate-${PV}:=
"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	eqmake6 PREFIX="${EPREFIX}/usr"
}

src_install() {
	emake INSTALL_ROOT="${ED}" install
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "gnuplot support" sci-libs/libqalculate[gnuplot]
}
