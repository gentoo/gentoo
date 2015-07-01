# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-DAV/HTTP-DAV-0.480.0.ebuild,v 1.1 2015/07/01 12:16:15 zlogene Exp $

EAPI=5

MODULE_AUTHOR=COSIMO
MODULE_VERSION=0.48
inherit perl-module

DESCRIPTION="A WebDAV client library for Perl5"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/URI
	dev-perl/XML-DOM
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
