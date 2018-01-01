# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils virtualx

DESCRIPTION="Tcl Standard Library"
HOMEPAGE="http://www.tcl.tk/software/tcllib/"
SRC_URI="
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.xz
	mirror://sourceforge/tcllib/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
IUSE="examples"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="dev-lang/tcl:0="
DEPEND="${RDEPEND}"

DOCS=( DESCRIPTION.txt STATUS )

PATCHES=(
	"${WORKDIR}"/${P}-patchset/${P}-tcl8.6-test.patch
	"${WORKDIR}"/${P}-patchset/${P}-test.patch
	"${WORKDIR}"/${P}-patchset/${P}-manpage-rename.patch
	"${WORKDIR}"/${P}-patchset/${P}-XSS-vuln.patch
)

src_prepare() {
	has_version ">=dev-lang/tcl-8.6" && \
		PATCHES+=( "${WORKDIR}"/${P}-patchset/${P}-tcl8.6-test-2.patch )
	epatch "${PATCHES[@]}"
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
