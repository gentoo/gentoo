# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator eutils autotools

DESCRIPTION="Archiver that creates standard zips to create identical files over multiple systems"
HOMEPAGE="https://sourceforge.net/projects/trrntzip"

S="${WORKDIR}/trrntzip-code-9"

SRC_URI="http://sourceforge.net/code-snapshots/svn/t/tr/trrntzip/code/trrntzip-code-9.zip"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND="sys-libs/zlib"
RDEPEND=""


src_unpack() {
	unpack ${A}
	cd "${S}"

	# Source-code from sf.net snapshots has CRLF...
	EPATCH_OPTS="--binary"
	epatch "${FILESDIR}"/fix-function-declarations.patch

	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install 
	nonfatal dodoc README AUTHORS
}
