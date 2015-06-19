# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X-Osd/X-Osd-0.700.0-r1.ebuild,v 1.1 2014/08/26 19:38:48 axs Exp $

EAPI=5

MODULE_AUTHOR=GOZER
MODULE_VERSION=0.7
inherit perl-module

DESCRIPTION="Perl glue to libxosd (X OnScreen Display)"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/xosd"
RDEPEND="${DEPEND}"
