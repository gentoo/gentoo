# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ELLIOTJS
MODULE_VERSION=1.108
inherit perl-module

DESCRIPTION="Perl::Critic policies which have been superseded by others"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/Readonly
	dev-perl/Perl-Critic"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
