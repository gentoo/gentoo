# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MIKEM
DIST_VERSION=1.32
inherit perl-module

DESCRIPTION="Perl extension for OpenSSL EC (Elliptic Curves) library"
SLOT="0"

KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Crypt-OpenSSL-Bignum-0.40.0
	dev-libs/openssl:=
"
DEPEND="
	dev-libs/openssl:=
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.320.0-perl-5.42.patch
)
