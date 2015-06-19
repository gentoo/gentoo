# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Config-AutoConf/Config-AutoConf-0.310.0.ebuild,v 1.1 2015/03/01 16:07:15 mrueg Exp $

EAPI=5

MODULE_AUTHOR="REHSACK"
MODULE_VERSION=${PV%.0}

inherit perl-module

DESCRIPTION="A module to implement some of AutoConf macros in pure perl"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( >=dev-perl/Test-Pod-1.14
	>=dev-perl/Test-Pod-Coverage-1.08 )"
RDEPEND="dev-perl/Capture-Tiny"

SRC_TEST="do"
