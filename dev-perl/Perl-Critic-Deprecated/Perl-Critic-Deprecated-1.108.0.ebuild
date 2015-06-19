# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perl-Critic-Deprecated/Perl-Critic-Deprecated-1.108.0.ebuild,v 1.4 2015/06/13 22:39:05 dilfridge Exp $

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
