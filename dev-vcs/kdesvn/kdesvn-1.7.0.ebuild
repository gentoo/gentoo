# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="optional"
KDE_LINGUAS="cs de el es fr it ja lt pt_BR ro ru"
KDE_LINGUAS_LIVE_OVERRIDE="true"
inherit flag-o-matic kde4-base

DESCRIPTION="A frontend to the subversion vcs"
HOMEPAGE="http://kdesvn.alwins-world.de/"
if [[ ${PV} != 9999* ]]; then
	SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
fi

LICENSE="GPL-2"
KEYWORDS="amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	dev-libs/apr:1
	dev-libs/apr-util:1
	dev-qt/qtsql:4[sqlite]
	>=dev-vcs/subversion-1.7
	sys-devel/gettext
"
RDEPEND="${DEPEND}
	!kde-apps/kdesdk-kioslaves:4[subversion(+)]
"

# bug #583286: needs network access
RESTRICT="test"

src_configure() {
	append-cppflags -DQT_THREAD_SUPPORT

	[[ ${PV} = 9999* ]] && local mycmakeargs=(-DDAILY_BUILD=ON)

	kde4-base_src_configure
}
