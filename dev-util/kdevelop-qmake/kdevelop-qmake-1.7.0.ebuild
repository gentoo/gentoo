# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDEBASE="kdevelop"
KMNAME="kdev-qmake"
inherit kde4-base

DESCRIPTION="qmake plugin for KDevelop 4"
SRC_URI="http://quickgit.kde.org/?p=${KMNAME}.git&a=snapshot&h=${PV%%.0} -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug tools"

DEPEND="
	dev-util/kdevelop:4
	dev-util/kdevelop-pg-qt:4
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${KMNAME}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build tools qmake_parser)
	)
	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install
	#Move this file to prevent a collision with kappwizard
	mv "${D}"/usr/share/apps/kdevappwizard/templates/qmake_qt4guiapp.tar.bz2 \
		"${D}"/usr/share/apps/kdevappwizard/templates/kdevelop-qmake_qt4guiapp.tar.bz2 \
		|| die
}
