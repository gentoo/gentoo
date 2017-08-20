# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ALEXMV
DIST_VERSION=1.3
inherit perl-module

DESCRIPTION="A co-operative multithreaded server using Coro"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

RDEPEND="
	dev-perl/Coro
	dev-perl/AnyEvent
	>=dev-perl/Net-Server-2
	ssl? (
		dev-perl/Net-SSLeay
	)
"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e 's/use inc::Module::Install/use lib q[.]; use inc::Module::Install/' Makefile.PL ||
		die "Can't patch Makefile.PL for 5.26 dot-in-inc"
	perl-module_src_prepare
}
