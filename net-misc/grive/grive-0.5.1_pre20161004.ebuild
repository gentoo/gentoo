# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/vitalif/${PN}2.git"
else
	inherit vcs-snapshot
	COMMIT="7bbb01c3014cc996ec24a7e5c0684f24b604b735"
	SRC_URI="https://github.com/vitalif/${PN}2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="An open source Linux client for Google Drive"
HOMEPAGE="https://github.com/vitalif/grive2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	dev-libs/expat
	>=dev-libs/json-c-0.11-r1:=
	dev-libs/libgcrypt:0=
	|| ( net-misc/curl[curl_ssl_openssl] net-misc/curl[curl_ssl_gnutls] )
	sys-libs/binutils-libs:0=
	sys-libs/glibc
	dev-libs/yajl
"
DEPEND="${RDEPEND}"
