# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=EHUELS
DIST_VERSION=2.1800
inherit perl-module

DESCRIPTION="Perl SASL interface"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~sparc ~x86"
IUSE="kerberos"

RDEPEND="
	dev-perl/Crypt-URandom
	dev-perl/Digest-HMAC
	kerberos? ( dev-perl/GSSAPI )
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.42
"

PATCHES=( "${FILESDIR}"/${PN}-2.180.0_CVE-2025-40918-r1.patch )
