# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-forensics/sleuthkit/sleuthkit-4.0.1.ebuild,v 1.5 2013/01/13 11:31:50 ago Exp $

EAPI="5"

inherit eutils autotools

DESCRIPTION="A collection of file system and media management forensic analysis tools"
HOMEPAGE="http://www.sleuthkit.org/sleuthkit/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 IBM"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="aff ewf static-libs"

DEPEND="dev-db/sqlite:3
	ewf? ( app-forensics/libewf )
	aff? ( app-forensics/afflib )"
RDEPEND="${DEPEND}
	dev-perl/DateManip"

DOCS=( NEWS.txt README.txt )

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0.0-system-sqlite.patch
	epatch "${FILESDIR}"/${PN}-3.2.3-tools-shared-libs.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with aff afflib) \
		$(use_with ewf libewf) \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
}
