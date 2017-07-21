# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit bash-completion-r1

DESCRIPTION="A command line twitter/identi.ca client"
HOMEPAGE="https://gregkh.github.com/bti/"
SRC_URI="mirror://kernel/software/web/bti/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

COMMON_DEPEND="
	dev-libs/json-c
	dev-libs/libpcre
	dev-libs/libxml2
	net-libs/liboauth
	net-misc/curl
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"
# Readline is dynamically loaded, for whatever reason, and can use
# libedit as an alternative...
RDEPEND="${COMMON_DEPEND}
	|| ( sys-libs/readline dev-libs/libedit )
"

DOCS=( bti.example ChangeLog README RELEASE-NOTES )

src_install() {
	default
	newbashcomp bti-bashcompletion ${PN}
}
