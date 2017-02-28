# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LBROCARD
MODULE_VERSION=0.33
inherit perl-module

DESCRIPTION="Send Messages using Gmail"

SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="test"

RDEPEND="dev-perl/Authen-SASL
	 dev-perl/Email-Address
	 dev-perl/Email-Send
	 dev-perl/Net-SMTP-SSL"

DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do parallel"
