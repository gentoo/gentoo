# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cache-Memcached-Fast/Cache-Memcached-Fast-0.210.0-r1.ebuild,v 1.1 2014/08/21 20:24:15 axs Exp $

EAPI=5

MODULE_AUTHOR=KROKI
MODULE_VERSION=0.21
inherit perl-module

DESCRIPTION="Perl client for memcached, in C language"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

SRC_TEST="do"

MAKEOPTS="${MAKEOPTS} -j1"
