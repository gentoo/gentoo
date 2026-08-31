# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="2D Math and Data plotter"
HOMEPAGE="https://zegrapher.com"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/AdelKS/ZeGrapher"
else
	SRC_URI="
		https://github.com/AdelKS/ZeGrapher/archive/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ZeGrapher-${PV}"
fi

LICENSE="AGPL-3+"
SLOT="0"
IUSE="debug test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-cpp/glaze-7.7.1
	dev-qt/qtbase:6[network]
	dev-qt/qtdeclarative:6[svg]
	dev-qt/qtsvg:6
"

DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		-Dloglevel=$(usex debug debug off)
		$(meson_use test)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
