# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

MY_PN=${PN}-fuse
MY_P=${MY_PN}-${PV}

DESCRIPTION="Amazon mounting S3 via fuse"
HOMEPAGE="https://github.com/s3fs-fuse/s3fs-fuse/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND=">=dev-libs/libxml2-2.6:2
	dev-libs/openssl
	>=net-misc/curl-7.0
	>=sys-fs/fuse-2.8.4"
RDEPEND="${CDEPEND}
	app-misc/mime-types"
DEPEND="${CDEPEND}
	virtual/pkgconfig"

RESTRICT="test"
