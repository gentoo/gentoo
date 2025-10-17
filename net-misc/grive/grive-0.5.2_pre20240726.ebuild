# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake vcs-snapshot

COMMIT="be52cb21a7ea5c16db0d5f3b22f1864629ff36ae"
SRC_URI="https://github.com/vitalif/${PN}2/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

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
