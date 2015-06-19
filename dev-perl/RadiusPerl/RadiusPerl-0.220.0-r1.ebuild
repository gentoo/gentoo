# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RadiusPerl/RadiusPerl-0.220.0-r1.ebuild,v 1.1 2014/08/23 00:22:04 axs Exp $

EAPI=5

MODULE_AUTHOR=MANOWAR
MODULE_VERSION=0.22
inherit perl-module

DESCRIPTION="Communicate with a Radius server from Perl"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 ~hppa ~sparc x86"
IUSE=""

DEPEND="
	>=virtual/perl-Digest-MD5-2.200.0
	>=virtual/perl-IO-1.12
	>=dev-perl/Data-HexDump-0.02
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/Authen-Radius-${MODULE_VERSION}

SRC_TEST="do"
export OPTIMIZE="$CFLAGS"
PATCHES=( "${FILESDIR}"/dictionary.cisco.ssg.patch )

src_prepare() {
	sed -i '/install-radius-db.PL/d' Makefile.PL MANIFEST || die
	mv "${S}"/install-radius-db.PL{,.orig} || die

	perl-module_src_prepare
}

src_install() {
	perl-module_src_install

	# Really want to install these radius dictionaries?
	insinto /etc/raddb
	doins raddb/dictionary*
}
