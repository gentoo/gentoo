# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MogileFS-Network/MogileFS-Network-0.060.0-r1.ebuild,v 1.1 2014/08/26 19:12:38 axs Exp $

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
	>=dev-perl/mogilefs-server-2.580.0"
#DEPEND="${RDEPEND}"
