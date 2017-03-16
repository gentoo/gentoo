# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_LINGUAS="bs cs da de el es et fi fr ga gl hu it ja km lt mr nds nl pl pt
pt_BR ro ru sk sl sv tr uk"
inherit kde4-base

DESCRIPTION="LightDM KDE greeter"
HOMEPAGE="https://projects.kde.org/projects/playground/base/lightdm"
SRC_URI="mirror://kde/unstable/${PN}/src/${P}.tar.bz2"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="4"
IUSE="debug"

COMMON_DEPEND="
	dev-qt/qtdeclarative:4
	x11-libs/libX11
	>=x11-misc/lightdm-1.4.0[qt4]
"
DEPEND="${COMMON_DEPEND}
	sys-devel/gettext
"
RDEPEND="${COMMON_DEPEND}
	$(add_kdeapps_dep plasma-runtime)
"

S=${WORKDIR}/${PN/-kde}-${PV}

PATCHES=( "${FILESDIR}/${P}-lightdm-1.7.patch" )
