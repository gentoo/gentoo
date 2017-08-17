# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el en_GB es et eu fi fr gl hu it km nb
nds nl pl pt pt_BR ro ru sk sv tr uk zh_CN zh_TW"
KDE_HANDBOOK="optional"
QT3SUPPORT_REQUIRED="true"
inherit kde4-base

DESCRIPTION="KDE graphviz dot graph file viewer"
HOMEPAGE="https://www.kde.org/applications/graphics/kgraphviewer/
https://extragear.kde.org/apps/kgraphviewer/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	>=media-gfx/graphviz-2.30
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.38
"
