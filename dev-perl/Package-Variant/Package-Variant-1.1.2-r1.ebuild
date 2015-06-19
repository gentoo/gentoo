# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Package-Variant/Package-Variant-1.1.2-r1.ebuild,v 1.1 2014/08/26 16:00:10 axs Exp $

EAPI=5

MODULE_AUTHOR=PHAYLON
MODULE_VERSION=1.001002
inherit perl-module

DESCRIPTION="Parameterizable packages"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-aix ~x86-solaris"
IUSE="test"

RDEPEND="
	>=dev-perl/strictures-1.0.0
	>=dev-perl/Module-Runtime-0.13.0
	>=dev-perl/Import-Into-1.0.0
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Fatal
	)
"

SRC_TEST=do
