# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NANIS
DIST_VERSION=0.72
inherit perl-module

DESCRIPTION="OpenSSL support for LWP"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-libs/openssl-0.9.7c:=
"
DEPEND="
	>=dev-libs/openssl-0.9.7c:=
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.280.205
	dev-perl/ExtUtils-PkgConfig
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

PATCHES=(
	"${FILESDIR}"/${PN}-0.72-Do-not-use-SSLv2_client_method-with-OpenSSL-1.1.0.patch
	"${FILESDIR}"/${PN}-0.72-Fix-building-on-Perl-without-dot-in-INC.patch
	"${FILESDIR}"/${PN}-0.72-Use-ExtUtils-PkgConfig-to-discover-OpenSSL-if-availa.patch
	"${FILESDIR}"/${PN}-0.72-Use_TLS_client_method-with-OpenSSL-1.1.1.patch
	"${FILESDIR}"/${PN}-0.72-Adapt-to-OpenSSL-4.patch
)
