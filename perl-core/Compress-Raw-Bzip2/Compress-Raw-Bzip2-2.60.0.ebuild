# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Compress-Raw-Bzip2/Compress-Raw-Bzip2-2.60.0.ebuild,v 1.16 2015/06/04 17:01:10 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=PMQS
MODULE_VERSION=2.060
inherit perl-module

DESCRIPTION="Low-Level Interface to bzip2 compression library"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-arch/bzip2"
DEPEND="${RDEPEND}"
#	test? ( dev-perl/Test-Pod )"

SRC_TEST=parallel

src_prepare() {
	rm -rf "${S}"/bzip2-src/ || die
	sed -i '/^bzip2-src/d' "${S}"/MANIFEST || die
	perl-module_src_prepare
}

src_configure(){
	BUILD_BZIP2=0 BZIP2_INCLUDE=. BZIP2_LIB= \
		perl-module_src_configure
}
