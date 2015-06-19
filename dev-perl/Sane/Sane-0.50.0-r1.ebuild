# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sane/Sane-0.50.0-r1.ebuild,v 1.2 2015/05/01 12:09:51 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RATCLIFFE
MODULE_VERSION=0.05
inherit perl-module

DESCRIPTION="The Sane module allows you to access SANE-compatible scanners in a Perl"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=media-gfx/sane-backends-1.0.19"
DEPEND="${RDEPEND}
	dev-perl/ExtUtils-Depends
	dev-perl/extutils-pkgconfig
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
