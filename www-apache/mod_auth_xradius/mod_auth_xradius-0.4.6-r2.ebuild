# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Radius authentication for Apache"
HOMEPAGE="http://www.outoforder.cc/projects/apache/mod_auth_xradius/"
SRC_URI="http://www.outoforder.cc/downloads/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="www-servers/apache"

PATCHES=(
	"${FILESDIR}"/${P}-obsolete-autotools-syntax.patch
	"${FILESDIR}"/${P}-fallback-support.patch
	"${FILESDIR}"/${P}-apache24-api-changes.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default
	AT_M4DIR="m4" eautoreconf
}
