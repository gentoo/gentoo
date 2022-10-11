# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="RJBS"
DIST_VERSION="0.018"

inherit perl-module

DESCRIPTION="Create and send Email:: emails using a Builder pattern"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Params-Util-1.102.0
	dev-perl/Email-MIME
	>=dev-perl/Email-Sender-1.300.35
	dev-perl/Module-Runtime
	dev-perl/Moo"

BDEPEND="${RDEPEND}
	test? ( dev-perl/Test-Fatal )"
