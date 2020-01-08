# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="A library which can read Excel (xls) files"
HOMEPAGE="http://libxls.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/libxls/${P}.zip"

LICENSE="GPL-2 LGPL-3"
SLOT="0/1" # libxlsreader.so.1
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"

RESTRICT=test # test driver is missing

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-asprintf.patch
	"${FILESDIR}"/${P}-infinite.patch
)

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default

	prune_libtool_files
}
