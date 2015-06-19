# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Curl/WWW-Curl-4.150.0-r1.ebuild,v 1.1 2014/08/22 20:36:15 axs Exp $

EAPI=5

MODULE_AUTHOR=SZBALINT
MODULE_VERSION=4.15
inherit perl-module

DESCRIPTION="Perl extension interface for libcurl"

LICENSE="|| ( MPL-1.0 MPL-1.1 MIT )"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

SRC_TEST=online
