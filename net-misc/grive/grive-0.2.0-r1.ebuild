# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils eutils multilib

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/Grive/${PN}.git"
else
	inherit eutils vcs-snapshot
	SRC_URI="mirror://github/Grive/${PN}/tarball/v${PV} -> ${P}.tar.gz"
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
	net-misc/curl
	sys-devel/binutils
	sys-libs/glibc
	sys-libs/zlib
	"

DEPEND="${RDEPEND}"

DOCS=( "README" )

src_prepare() {
	epatch "${FILESDIR}"/"${P}"-check-bfd.h.patch

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
}
