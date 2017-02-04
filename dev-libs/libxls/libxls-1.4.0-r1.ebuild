# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="A library which can read Excel (xls) files"
HOMEPAGE="http://libxls.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/libxls/${P}.zip"

LICENSE="GPL-2 LGPL-3"
SLOT="0/1" # libxlsreader.so.1
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/pkgconfig"

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
