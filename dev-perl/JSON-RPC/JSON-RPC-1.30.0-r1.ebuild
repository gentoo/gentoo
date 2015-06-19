# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON-RPC/JSON-RPC-1.30.0-r1.ebuild,v 1.1 2014/08/24 02:04:59 axs Exp $

EAPI=5

MODULE_AUTHOR=DMAKI
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="JSON RPC 2.0 Server Implementation"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Class-Accessor-Lite
	dev-perl/libwww-perl
	>=dev-perl/JSON-2.21
	dev-perl/Plack
	dev-perl/Router-Simple
	dev-perl/Try-Tiny
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST="do"
pm_echovar="y"
