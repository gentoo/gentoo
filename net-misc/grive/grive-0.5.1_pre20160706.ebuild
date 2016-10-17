# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

if [[ ${PV} = *9999 ]]; then
	inherit git-2
	EGIT_REPO_URI="git://github.com/vitalif/${PN}2.git"
else
	inherit vcs-snapshot
	COMMIT="457d84974592ed3f123622b12f2a7a748cbc0668"
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
	net-misc/curl[curl_ssl_gnutls]
	sys-libs/binutils-libs:0=
	sys-libs/glibc
	dev-libs/yajl
"
DEPEND="${RDEPEND}"
