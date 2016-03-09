# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=RHANDOM
MODULE_VERSION=2.008
inherit perl-module eutils

DESCRIPTION="Extensible, general Perl server engine"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="ipv6"

RDEPEND="dev-perl/IO-Multiplex
	ipv6? ( dev-perl/IO-Socket-INET6 )"
DEPEND="${RDEPEND}"

SRC_TEST="do"
