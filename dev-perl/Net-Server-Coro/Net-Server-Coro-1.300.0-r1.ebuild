# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=ALEXMV
MODULE_VERSION=1.3
inherit perl-module

DESCRIPTION="A co-operative multithreaded server using Coro"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND="
	dev-perl/Coro
	dev-perl/AnyEvent
	>=dev-perl/net-server-2
	ssl? (
		dev-perl/Net-SSLeay
	)
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
