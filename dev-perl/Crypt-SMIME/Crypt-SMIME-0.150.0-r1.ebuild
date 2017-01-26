# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIKAGE
MODULE_VERSION=0.15
inherit perl-module

DESCRIPTION="S/MIME message signing, verification, encryption and decryption"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl test"

RDEPEND="
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	dev-perl/ExtUtils-PkgConfig
	dev-perl/ExtUtils-CChecker
	test? (
		dev-perl/Test-Exception
		virtual/perl-Test-Simple
		>=dev-perl/Test-Taint-1.60.0
	)
"
src_test() {
	perl_rm_files t/boilerplate.t t/manifest.t t/dependencies.t \
		t/pod-coverage.t t/pod.t
	perl-module_src_test
}

SRC_TEST=do
