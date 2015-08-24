# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="ar bg bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga gl
hu it ja kk km ko lt mai mr ms nb nds nl pa pl pt pt_BR ro ru sk sl sr
sr@ijekavian sr@ijekavianlatin sr@Latn sv th tr ug uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="Bluetooth stack for KDE"
HOMEPAGE="https://projects.kde.org/projects/extragear/base/bluedevil"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="debug"

RDEPEND="
	>=net-libs/libbluedevil-2.1:4
	x11-misc/shared-mime-info
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"
