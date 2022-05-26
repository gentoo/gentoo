# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TIMPOTTER
DIST_VERSION=0.01
DIST_WIKI="tests"
inherit perl-module

DESCRIPTION="Utility routines for use with Net::Pcap"

SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-perl/Net-Pcap"
BDEPEND="${RDEPEND}"

PATCHES=("${FILESDIR}/${PN}-0.01-testsuite.patch")
