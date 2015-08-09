# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit bash-completion-r1 eutils

DESCRIPTION="A command line twitter/identi.ca client"
HOMEPAGE="http://gregkh.github.com/bti/"
SRC_URI="mirror://kernel/software/web/bti/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND="
	net-misc/curl
	dev-libs/libxml2
	dev-libs/libpcre
	net-libs/liboauth
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

# Readline is dynamically loaded, for whatever reason, and can use
# libedit as an alternative...
RDEPEND="${RDEPEND}
	|| ( sys-libs/readline dev-libs/libedit )"

DOCS=( bti.example README RELEASE-NOTES )

src_prepare() {
	# Allow compilation on non-GNU systems, bug #384311
	epatch "${FILESDIR}/${PN}-031-nonGNU.patch"
}

src_install() {
	default
	dobashcomp bti-bashcompletion
}
