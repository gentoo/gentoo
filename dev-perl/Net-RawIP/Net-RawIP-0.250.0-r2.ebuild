# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SAPER
DIST_VERSION=0.25
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Raw IP packets manipulation Module"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE=""

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"
PERL_RM_FILES=( "t/90-pod.t" "t/91-pod-coverage.t" "t/99-critic.t" )
PATCHES=("${FILESDIR}/${PN}-0.25-no-network-tests.patch")
