# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DAGOLDEN"
DIST_VERSION="1.000"

inherit perl-module

DESCRIPTION="Encrypted, expiring, compressed, serialized session data with integrity"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Sereal-Decoder
	dev-perl/Crypt-Rijndael
	dev-perl/String-Compare-ConstantTime
	>=dev-perl/Crypt-CBC-3.40.0
	dev-perl/Math-Random-ISAAC-XS
	>=dev-perl/MooX-Types-MooseLike-0.290.0
	dev-perl/Moo
	dev-perl/Number-Tolerant
	dev-perl/Crypt-URandom
	dev-perl/Sereal-Encoder
	dev-perl/namespace-clean"

BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Fatal
		dev-perl/Test-Deep
	)"
