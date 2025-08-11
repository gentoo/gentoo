# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMLEGGE
DIST_VERSION=1.19
inherit perl-module

DESCRIPTION="DSA Signatures and Key Generation"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

RDEPEND="
	dev-perl/Convert-ASN1
	>=dev-perl/Convert-PEM-0.130.0
	dev-perl/Crypt-URandom
	>=dev-perl/Data-Buffer-0.10.0
	dev-perl/Digest-SHA1
	>=dev-perl/File-Which-0.50.0
"
# Math::BigInt::GMP is used in e.g. 03-keygen.t, otherwise it's skipped
# for being too slow.
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Math-BigInt-GMP
	)
"
