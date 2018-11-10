# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SAPER
MODULE_VERSION=0.25
inherit perl-module

DESCRIPTION="Perl Net::RawIP - Raw IP packets manipulation Module"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
