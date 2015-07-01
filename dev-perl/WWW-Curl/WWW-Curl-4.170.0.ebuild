# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Curl/WWW-Curl-4.170.0.ebuild,v 1.1 2015/07/01 12:05:38 zlogene Exp $

EAPI=5

MODULE_AUTHOR=SZBALINT
MODULE_VERSION=4.17
inherit perl-module

DESCRIPTION="Perl extension interface for libcurl"

LICENSE="|| ( MPL-1.0 MPL-1.1 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

SRC_TEST=online
