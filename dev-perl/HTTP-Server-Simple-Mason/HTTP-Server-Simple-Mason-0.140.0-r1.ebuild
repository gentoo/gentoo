# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTTP-Server-Simple-Mason/HTTP-Server-Simple-Mason-0.140.0-r1.ebuild,v 1.1 2014/08/24 02:03:55 axs Exp $

EAPI=5

MODULE_AUTHOR=JESSE
MODULE_VERSION=0.14
inherit perl-module

DESCRIPTION="An abstract baseclass for a standalone mason server"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND="dev-perl/Hook-LexWrap
	dev-perl/URI
	dev-perl/libwww-perl
	>=dev-perl/HTML-Mason-1.25
	>=dev-perl/HTTP-Server-Simple-0.04"
RDEPEND="${DEPEND}"

SRC_TEST="do"
