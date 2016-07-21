# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils virtualx

DESCRIPTION="Tcl Standard Library"
HOMEPAGE="http://www.tcl.tk/software/tcllib/"
SRC_URI="
	https://dev.gentoo.org/~jlec/distfiles/${P}-manpage-rename.patch.xz
	https://dev.gentoo.org/~jlec/distfiles/${P}-test.patch.xz
	mirror://sourceforge/tcllib/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
IUSE="examples"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="dev-lang/tcl:0="
DEPEND="${RDEPEND}"

DOCS=( DESCRIPTION.txt STATUS )

PATCHES=(
	"${FILESDIR}"/${P}-tcl8.6-test.patch
	"${WORKDIR}"/${P}-test.patch
	"${WORKDIR}"/${P}-manpage-rename.patch
	"${FILESDIR}"/${P}-XSS-vuln.patch
)

src_prepare() {
	has_version ">=dev-lang/tcl-8.6" && \
		PATCHES+=( "${FILESDIR}"/${P}-test.patch )
	epatch ${PATCHES[@]}
}

src_test() {
	Xemake test_batch
}

src_install() {
	default

	dodoc devdoc/*.txt

	dohtml devdoc/*.html
	if use examples ; then
		for f in $(find examples -type f); do
			docinto $(dirname $f)
			dodoc $f
		done
	fi
}
