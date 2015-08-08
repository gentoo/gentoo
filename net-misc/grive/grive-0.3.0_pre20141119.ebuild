# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/linwiz/${PN}.git"
else
	inherit vcs-snapshot
	COMMIT="afd106ff47758d74daac4db35002e5e0d8d4d389"
	SRC_URI="https://github.com/linwiz/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
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
	>=dev-libs/json-c-0.11-r1:=
	dev-libs/libgcrypt:0=
	net-misc/curl
	sys-libs/glibc
	dev-libs/yajl
	"

DEPEND="${RDEPEND}"

DOCS=( "README" )
