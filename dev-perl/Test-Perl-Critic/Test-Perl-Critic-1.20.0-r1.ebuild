# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Perl-Critic/Test-Perl-Critic-1.20.0-r1.ebuild,v 1.2 2015/06/13 21:57:47 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=THALJEF
MODULE_VERSION=1.02
inherit perl-module

DESCRIPTION="Use Perl::Critic in test programs"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="test"

RDEPEND=">=dev-perl/Perl-Critic-1.105"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do
