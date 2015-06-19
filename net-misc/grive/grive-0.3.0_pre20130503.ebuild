# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/grive/grive-0.3.0_pre20130503.ebuild,v 1.2 2014/05/15 15:28:31 kensington Exp $

EAPI=5

inherit cmake-utils eutils multilib

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Grive/${PN}.git"
else
	inherit eutils vcs-snapshot
	COMMIT="27817e835fe115ebbda5410ec904aa49a2ad01f1"
	SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="an open source Linux client for Google Drive"
HOMEPAGE="http://www.lbreda.com/grive/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-libs/expat
	dev-libs/json-c:=
	dev-libs/libgcrypt:0=
	dev-libs/yajl
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	net-misc/curl
	sys-devel/binutils
	sys-libs/glibc
	sys-libs/zlib
	"

DEPEND="${RDEPEND}"

DOCS=( "README" )

src_prepare() {
	epatch "${FILESDIR}/${PN}"-0.2.0-check-bfd.h.patch

	#include dir change in json-c-0.10 #462632 and #452234
	if has_version ">=dev-libs/json-c-0.10" ; then
		sed -i -e '/\(include\|INCLUDE\)/s@json/@json-c/@' \
			libgrive/src/protocol/Json.cc \
			cmake/Modules/FindJSONC.cmake || die
	fi
	#json-c library changed in 0.11, bug #467432
	if has_version ">=dev-libs/json-c-0.11" ; then
		sed -i -e '/LIBRARY/s@json)@json-c)@' \
			cmake/Modules/FindJSONC.cmake || die
	fi

	sed -i '/grive.1/s/^/#/' bgrive/CMakeLists.txt || die
}

src_install(){
	cmake-utils_src_install

	local icon size
	for icon in icon/*/*.png; do
		size=${icon##*/}
		size=${size%.png}
		newicon -s "${size}" "${icon}" ${PN}.png
	done
	make_desktop_entry bgrive
}
