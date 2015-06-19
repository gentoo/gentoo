# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/AnyEvent-HTTP/AnyEvent-HTTP-2.150.0-r1.ebuild,v 1.1 2014/08/22 21:16:27 axs Exp $

EAPI=5

MODULE_AUTHOR=MLEHMANN
MODULE_VERSION=2.15
inherit perl-module

DESCRIPTION="Simple but non-blocking HTTP/HTTPS client"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-perl/AnyEvent-6
	dev-perl/common-sense"
DEPEND="${RDEPEND}"

SRC_TEST="do"
