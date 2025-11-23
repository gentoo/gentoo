# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AWESTHOLM
DIST_VERSION=0.12
inherit perl-module

DESCRIPTION="A SMTP client supporting TLS and AUTH"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/Net-SSLeay
	dev-perl/IO-Socket-SSL
	virtual/perl-MIME-Base64
	dev-perl/Digest-HMAC"
BDEPEND="${RDEPEND}
"

PATCHES=( "${FILESDIR}/${PV}-multiple-attachments-fix.patch" )
