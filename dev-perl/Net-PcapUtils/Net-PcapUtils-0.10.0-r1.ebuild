# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-PcapUtils/Net-PcapUtils-0.10.0-r1.ebuild,v 1.1 2014/08/24 12:50:45 axs Exp $

EAPI=5

MODULE_AUTHOR=TIMPOTTER
MODULE_VERSION=0.01
inherit perl-module

DESCRIPTION="Perl Net::PcapUtils - Net::Pcap library utils"

SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-perl/Net-Pcap"
DEPEND="${RDEPEND}"
