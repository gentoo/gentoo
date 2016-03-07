# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE legacy icons"
SRC_URI="mirror://kde/stable/applications/15.08.0/src/kde-workspace-4.11.22.tar.xz"

KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="
	!<kde-base/systemsettings-4.11.22-r1:4
	!>=kde-frameworks/oxygen-icons-5.19.0:5
"

S="${WORKDIR}"

src_prepare() {

	cat <<-EOF > CMakeLists.txt || die
project(legacy-icons)
cmake_minimum_required(VERSION 2.8.12)
find_package(KDE4 REQUIRED)
include(KDE4Defaults)
add_subdirectory(systemsettings)
EOF

	# bug 574778 (kde-frameworks/oxygen-icons-5.19.0)
	mv kde-workspace-4.11.22/kcontrol/kfontinst/kio systemsettings || die
	echo "kde4_install_icons(\${ICON_INSTALL_DIR})" > \
		systemsettings/CMakeLists.txt || die

	kde4-base_src_prepare
}
