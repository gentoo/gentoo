# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=MIKAGE
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="S/MIME message signing, verification, encryption and decryption"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl test minimal"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/extutils-pkgconfig
	dev-perl/ExtUtils-CChecker
	>=virtual/perl-ExtUtils-Constant-0.230.0
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		!minimal? (
			>=dev-perl/Test-Taint-1.60.0
			>=dev-perl/Taint-Util-0.80.0
		)
	)
"

src_test() {
	perl_rm_files t/boilerplate.t t/manifest.t t/dependencies.t \
		t/pod-coverage.t t/pod.t
	perl-module_src_test
}
