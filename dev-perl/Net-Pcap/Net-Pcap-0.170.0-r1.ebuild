# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Pcap/Net-Pcap-0.170.0-r1.ebuild,v 1.1 2014/08/24 12:42:24 axs Exp $

EAPI=5

MODULE_AUTHOR=SAPER
MODULE_VERSION=0.17
inherit perl-module eutils

DESCRIPTION="Perl Net::Pcap - Perl binding to the LBL pcap"

SLOT="0"
KEYWORDS="~alpha amd64 ppc x86"
IUSE=""

RDEPEND="net-libs/libpcap
	dev-perl/IO-Interface"
DEPEND="${RDEPEND}"
