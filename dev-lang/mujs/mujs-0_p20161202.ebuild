# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic toolchain-funcs vcs-snapshot

DESCRIPTION="lightweight Javascript interpreter"
HOMEPAGE="http://mujs.com/"
SRC_URI="http://git.ghostscript.com/?p=mujs.git;a=snapshot;h=fd003eceda531e13fbdd1aeb6e9c73156496e569;sf=tgz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0_p20150202-Makefile.patch"
	# workaround for linkage of app-text/mupdf-1.7a
	# TODO: generate a shared library and IUSE=static-libs
)

src_prepare() {
	default
	append-cflags -fPIC
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" install
}
