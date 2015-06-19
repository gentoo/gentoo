# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Data-Compare/Data-Compare-1.220.0-r1.ebuild,v 1.1 2014/08/24 01:24:41 axs Exp $

EAPI=5

MODULE_AUTHOR=DCANTRELL
MODULE_VERSION=1.22
inherit perl-module

DESCRIPTION="compare perl data structures"

SLOT="0"
KEYWORDS="amd64 hppa ~ppc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="test"

RDEPEND="dev-perl/File-Find-Rule
	dev-perl/Scalar-Properties"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Clone
		dev-perl/Test-Pod
	)"

SRC_TEST="do"
