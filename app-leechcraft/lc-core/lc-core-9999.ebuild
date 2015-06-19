# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-leechcraft/lc-core/lc-core-9999.ebuild,v 1.9 2015/06/04 18:59:50 kensington Exp $

EAPI="5"

EGIT_REPO_URI="git://github.com/0xd34df00d/leechcraft.git"
EGIT_PROJECT="leechcraft-${PV}"

inherit eutils confutils leechcraft

DESCRIPTION="Core of LeechCraft, the modular network client"

SLOT="0"
KEYWORDS=""
IUSE="debug doc +sqlite postgres +qwt"

COMMON_DEPEND=">=dev-libs/boost-1.46
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtdeclarative:4
	dev-qt/qtgui:4
	dev-qt/qtscript:4
	dev-qt/qtsql:4[postgres?,sqlite?]
	dev-qt/qtwebkit:4
	dev-qt/qtdbus:4
	qwt? ( x11-libs/qwt:6 )"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )"
RDEPEND="${COMMON_DEPEND}
	dev-qt/qtsvg:4
	|| (
		kde-apps/oxygen-icons
		x11-themes/kfaenza
	 )"

REQUIRED_USE="|| ( postgres sqlite )"

src_configure() {
	local mycmakeargs=(
		-DWITH_PLUGINS=False
		$(cmake-utils_use_with doc DOCS)
		$(cmake-utils_use_with qwt QWT)
	)
	if [[ ${PV} != 9999 ]]; then
		mycmakeargs+=( -DLEECHCRAFT_VERSION=${PV} )
	fi
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}/${PN#lc-}"/out/html/*
}
