# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde4-base

DESCRIPTION="KDE legacy icons"
SRC_URI="
	mirror://kde/stable/applications/15.08.0/src/kde-workspace-4.11.22.tar.xz
	mirror://kde/Attic/applications/15.04.3/src/kwalletmanager-15.04.3.tar.xz
	mirror://kde/stable/applications/15.08.3/src/libkipi-15.08.3.tar.xz
	mirror://kde/stable/applications/15.08.3/src/libksane-15.08.3.tar.xz
"

KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="
	!<kde-apps/kwalletmanager-15.04.3-r1:4
	!kde-apps/kwalletmanager:5
	!<kde-apps/libkipi-15.08.3-r1:4
	!kde-apps/libkipi:5
	!<kde-apps/libksane-15.08.3-r1:4
	!kde-apps/libksane:5
	!<kde-base/systemsettings-4.11.22-r1:4
	!=kde-frameworks/oxygen-icons-5.19.0:5
	!=kde-frameworks/oxygen-icons-5.20.0:5
"

S="${WORKDIR}"

src_prepare() {
	prepare_icons() {
		local _source=${1}
		local _dest=${2}
		local _dir=${3}
		echo "add_subdirectory(${_dest})" >> CMakeLists.txt || die
		mv ${_source}/${_dir} ${_dest} || die
		echo "kde4_install_icons( \${ICON_INSTALL_DIR} )" > \
			${_dest}/CMakeLists.txt || die
		rm -r ${_source} || die
	}

	cat <<-EOF > CMakeLists.txt || die
project(legacy-icons)
cmake_minimum_required(VERSION 2.8.12)
find_package(KDE4 REQUIRED)
include(KDE4Defaults)
EOF

	prepare_icons kwalletmanager-15.04.3 kwalletmanager src/manager
	prepare_icons libkipi-15.08.3 libkipi pics
	prepare_icons libksane-15.08.3 libksane libksane
	# bug 574778 (kde-frameworks/oxygen-icons-5.19.0)
	prepare_icons kde-workspace-4.11.22 systemsettings kcontrol/kfontinst/kio

	kde4-base_src_prepare
}
