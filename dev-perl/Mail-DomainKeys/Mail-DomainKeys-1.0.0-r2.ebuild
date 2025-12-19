# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANTHONYU
DIST_VERSION=1.0
inherit perl-module

DESCRIPTION="A perl implementation of DomainKeys"

SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 x86"

RDEPEND="
	>=dev-perl/Net-DNS-0.34
	dev-perl/MailTools
	dev-perl/Crypt-OpenSSL-RSA
"
BDEPEND="${RDEPEND}
	test? ( dev-perl/Email-Address )"
