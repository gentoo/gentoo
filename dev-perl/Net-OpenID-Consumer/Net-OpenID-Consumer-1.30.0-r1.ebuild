# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-OpenID-Consumer/Net-OpenID-Consumer-1.30.0-r1.ebuild,v 1.1 2014/08/26 19:34:33 axs Exp $

EAPI=5

MODULE_AUTHOR=MART
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="Library for consumers of OpenID identities"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/crypt-dh
	dev-perl/XML-Simple
	dev-perl/Digest-SHA1
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/URI-Fetch
	virtual/perl-Time-Local
	virtual/perl-MIME-Base64"
DEPEND="${RDEPEND}"

SRC_TEST=do
