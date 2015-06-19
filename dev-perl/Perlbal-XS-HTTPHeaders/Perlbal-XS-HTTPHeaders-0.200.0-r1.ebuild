# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perlbal-XS-HTTPHeaders/Perlbal-XS-HTTPHeaders-0.200.0-r1.ebuild,v 1.1 2014/08/26 19:10:28 axs Exp $

EAPI=5

MODULE_AUTHOR=DORMANDO
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="XS acceleration for Perlbal header processing"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-perl/Perlbal"
DEPEND="${RDEPEND}"
