# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Audio-Musepack/Audio-Musepack-1.0.1.ebuild,v 1.1 2014/12/07 14:14:40 dilfridge Exp $

EAPI=5
MODULE_AUTHOR=DANIEL
inherit perl-module

DESCRIPTION="An OO interface to Musepack file information and APE tag fields"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND=">=dev-perl/Audio-Scan-0.850.0"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}"

SRC_TEST="do parallel"
