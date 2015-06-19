# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PerlIO-gzip/PerlIO-gzip-0.180.0-r1.ebuild,v 1.2 2014/09/28 15:53:17 zlogene Exp $

EAPI=5

MODULE_AUTHOR=NWCLARK
MODULE_VERSION=0.18
inherit perl-module

DESCRIPTION="PerlIO::Gzip - PerlIO layer to gzip/gunzip"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/perl-5.20-build.patch" )

SRC_TEST="do"
