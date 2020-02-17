# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vitalif/${MY_PN}.git"
else
	SRC_URI="https://github.com/vitalif/${MY_PN}2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
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
	dev-libs/yajl
	|| ( net-misc/curl[curl_ssl_openssl] net-misc/curl[curl_ssl_gnutls] )
	sys-libs/binutils-libs:0=
	sys-libs/glibc
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	cmake-utils_src_prepare

	has_version ">=sys-libs/binutils-libs-2.34" && \
		eapply "${FILESDIR}/grive-0.5.1-binutils-2.34.patch"
}
