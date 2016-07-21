# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="ast bg bs cs da de en_GB eo es et fi fr ga gl hu it ja lt mai mr nds
nl pl pt pt_BR ru sk sv tr ug uk zh_CN"
inherit kde4-base

DESCRIPTION="Software for operating a small business, creating documents such as invoices"
HOMEPAGE="http://www.volle-kraft-voraus.de/"
SRC_URI="mirror://sourceforge/kraft/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	dev-cpp/ctemplate
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4[mysql,sqlite]
	$(add_kdeapps_dep kdepimlibs)
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS Changes.txt README Releasenotes.txt TODO )
