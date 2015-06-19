# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Carp-Assert-More/Carp-Assert-More-1.140.0.ebuild,v 1.5 2013/05/25 07:58:21 ago Exp $

EAPI=5

MODULE_AUTHOR=PETDANCE
MODULE_VERSION=1.14
inherit perl-module

DESCRIPTION="convenience wrappers around Carp::Assert"

SLOT="0"
KEYWORDS="amd64 ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="virtual/perl-Scalar-List-Utils
	dev-perl/Carp-Assert"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Exception )"

SRC_TEST="do"
