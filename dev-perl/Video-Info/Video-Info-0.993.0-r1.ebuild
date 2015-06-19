# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Video-Info/Video-Info-0.993.0-r1.ebuild,v 1.1 2014/08/23 00:30:04 axs Exp $

EAPI=5

MODULE_AUTHOR=ALLENDAY
MODULE_VERSION=0.993
inherit perl-module

DESCRIPTION="Perl extension for getting video info"

LICENSE="Aladdin"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc sparc x86"
IUSE=""

DEPEND="dev-perl/Class-MakeMethods"
RDEPEND="${DEPEND}"
