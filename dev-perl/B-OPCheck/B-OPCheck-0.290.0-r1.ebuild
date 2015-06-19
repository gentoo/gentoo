# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/B-OPCheck/B-OPCheck-0.290.0-r1.ebuild,v 1.3 2015/05/01 11:48:58 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=FLORA
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="PL_check hacks using Perl callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/B-Utils-0.250.0
	dev-perl/Scope-Guard"
DEPEND="${RDEPEND}
	>=dev-perl/ExtUtils-Depends-0.302"

PATCHES=( "${FILESDIR}"/0.29-Perl_check_t.patch )
SRC_TEST=do
