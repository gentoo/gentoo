# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils

DESCRIPTION="A programmer's API and an end-user's toolkit for handling BAM files"
HOMEPAGE="https://github.com/pezmaster31/bamtools"
SRC_URI="mirror://github/pezmaster31/bamtools/"${P}".tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_install() {
	for i in bin/bamtools-${PV} lib/libbamtools.so.${PV} lib/libbamtools-utils.so.${PV}; do
		TMPDIR="$(pwd)" scanelf -Xr $i || die
	done

	dobin bin/bamtools
	dolib lib/*
	insinto /usr/include/bamtools/api
	doins include/api/*
	insinto /usr/include/bamtools/shared
	doins include/shared/*
	dodoc README
}
