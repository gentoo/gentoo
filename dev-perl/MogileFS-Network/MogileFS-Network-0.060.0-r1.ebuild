# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="HACHI"
MODULE_VERSION=${PV:0:4}

inherit perl-module

DESCRIPTION="Network awareness and extensions for MogileFS::Server"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE=""

RDEPEND="dev-perl/Net-Netmask
	dev-perl/Net-Patricia
	>=dev-perl/MogileFS-Server-2.580.0"
#DEPEND="${RDEPEND}"
