# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ANTHONYU
MODULE_VERSION=1.0
inherit perl-module

DESCRIPTION="A perl implementation of DomainKeys"

SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-perl/Net-DNS-0.34
	dev-perl/MailTools
	dev-perl/Crypt-OpenSSL-RSA"
DEPEND="${RDEPEND}
	test? ( dev-perl/Email-Address )"

SRC_TEST="do"
