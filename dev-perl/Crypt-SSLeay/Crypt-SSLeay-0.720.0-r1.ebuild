# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=NANIS
MODULE_VERSION=0.72
inherit perl-module

DESCRIPTION="OpenSSL support for LWP"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libressl test"

RDEPEND="
	!libressl? ( >=dev-libs/openssl-0.9.7c:0 )
	libressl? ( dev-libs/libressl )
	virtual/perl-MIME-Base64
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	>=virtual/perl-ExtUtils-CBuilder-0.280.205
	virtual/perl-Getopt-Long
	>=dev-perl/Path-Class-0.260.0
	>=dev-perl/Try-Tiny-0.190.0
	test? (
		>=virtual/perl-Test-Simple-0.190.0
	)
"
# PDEPEND: circular dependencies bug #144761
PDEPEND="
	dev-perl/libwww-perl
	>=dev-perl/LWP-Protocol-https-6.20.0
"

export OPTIMIZE="${CFLAGS}"
#myconf="--lib=${EPREFIX}/usr"

SRC_TEST=do
