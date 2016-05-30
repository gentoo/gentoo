# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs vcs-snapshot

DESCRIPTION="lightweight Javascript interpreter"
HOMEPAGE="http://mujs.com/"
SRC_URI="http://git.ghostscript.com/?p=mujs.git;a=snapshot;h=1930f35933654d02234249b8c9b8c0d1c8c9fb6b;sf=tgz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0_p20150202-Makefile.patch
	# workaround for linkage of app-text/mupdf-1.7a
	# TODO: generate a shared library and IUSE=static-libs
	append-cflags -fPIC
	tc-export CC
}
