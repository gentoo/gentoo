# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-BufferedSelect/IO-BufferedSelect-1.0.0-r1.ebuild,v 1.1 2014/08/22 19:26:02 axs Exp $

EAPI=5

MODULE_AUTHOR=AFN
MODULE_VERSION=1.0
inherit perl-module

DESCRIPTION="Perl module that implements a line-buffered select interface"

SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

S="${WORKDIR}/${PN}"
