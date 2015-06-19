# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Tie-Hash-Method/Tie-Hash-Method-0.20.0.ebuild,v 1.2 2013/07/30 22:35:56 zlogene Exp $

EAPI=5

MODULE_AUTHOR=YVES
MODULE_VERSION=0.02

inherit perl-module

DESCRIPTION="Tied hash with specific methods overriden by callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-perl/Test-Pod )"

SRC_TEST="do parallel"
