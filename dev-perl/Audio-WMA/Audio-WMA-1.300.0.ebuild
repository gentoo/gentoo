# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-WMA/Audio-WMA-1.300.0.ebuild,v 1.1 2014/12/07 14:22:55 dilfridge Exp $

EAPI=5

MODULE_VERSION=1.3
MODULE_AUTHOR=DANIEL
inherit perl-module

DESCRIPTION="extension for reading WMA/ASF metadata"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="
	test? ( dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST="do parallel"
