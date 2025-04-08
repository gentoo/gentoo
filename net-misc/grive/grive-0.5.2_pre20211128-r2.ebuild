# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vitalif/${PN}2.git"
else
	inherit vcs-snapshot
	COMMIT="6901fbb169eaae51acb61778760ba2ac019675ae"
	SRC_URI="https://github.com/vitalif/${PN}2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
fi

DESCRIPTION="An open source Linux client for Google Drive"
HOMEPAGE="https://github.com/vitalif/grive2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boost:=
	dev-libs/expat
	>=dev-libs/json-c-0.11-r1:=
	dev-libs/libgcrypt:0=
	dev-libs/yajl
	|| ( net-misc/curl[curl_ssl_openssl] net-misc/curl[curl_ssl_gnutls] )
	sys-libs/binutils-libs:0=
	sys-libs/glibc
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/363.patch" )
