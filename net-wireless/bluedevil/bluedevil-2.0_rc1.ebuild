# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/bluedevil/bluedevil-2.0_rc1.ebuild,v 1.7 2014/12/12 16:53:10 pacho Exp $

EAPI=5

KDE_LINGUAS="ar bs ca ca@valencia cs da de el en_GB eo es et eu fa fi fr ga gl
hu it ja kk km ko lt mai mr ms nb nds nl pa pl pt pt_BR ro ru sk sl sr
sr@ijekavian sr@ijekavianlatin sr@latin sv th tr ug uk zh_CN zh_TW"
inherit kde4-base

MY_P=${PN}-${PV/_/-}
DESCRIPTION="Bluetooth stack for KDE"
HOMEPAGE="http://projects.kde.org/projects/extragear/base/bluedevil"
SRC_URI="mirror://kde/unstable/${PN}/${PV/_/-}/src/${MY_P}.tar.xz"

LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
SLOT="4"
IUSE="debug"

DEPEND="
	>=net-libs/libbluedevil-2:4
	x11-misc/shared-mime-info
"
RDEPEND="${DEPEND}"
S=${WORKDIR}/${MY_P}
