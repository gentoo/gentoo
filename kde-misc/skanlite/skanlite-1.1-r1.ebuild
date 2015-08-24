# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="be bs ca ca@valencia cs da de el en_GB eo es et eu fi fr ga gl hr
hu ia is it ja km ko lt lv mai mr nb nds nl nn pa pl pt pt_BR ro ru sk sl sq sv
tr ug uk wa zh_CN zh_TW"
KDE_DOC_DIRS="doc doc-translations/%lingua_${PN}"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE image scanning application"
HOMEPAGE="https://www.kde.org/applications/graphics/skanlite/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	$(add_kdeapps_dep libksane)
	media-libs/libpng:0="
DEPEND="${RDEPEND}
	sys-devel/gettext"
