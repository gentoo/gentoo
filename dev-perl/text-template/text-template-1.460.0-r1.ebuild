# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/text-template/text-template-1.460.0-r1.ebuild,v 1.1 2014/08/22 20:28:30 axs Exp $

EAPI=5

MY_PN=Text-Template
MODULE_AUTHOR=MJD
MODULE_VERSION=1.46
inherit perl-module

DESCRIPTION="Expand template text with embedded Perl"

LICENSE="|| ( Artistic GPL-2 GPL-3 )" # Artistic or GPL-2+
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc x86 ~ppc-macos"
IUSE=""

SRC_TEST=do
