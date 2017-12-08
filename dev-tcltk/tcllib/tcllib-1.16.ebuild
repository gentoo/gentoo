# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils virtualx

MY_PN=Tcllib
MY_P=${MY_PN}-${PV}

DESCRIPTION="Tcl Standard Library"
HOMEPAGE="http://www.tcl.tk/software/tcllib/"
SRC_URI="mirror://sourceforge//project/${PN}/${PN}/${PV}/${MY_P}.tar.bz2
	https://dev.gentoo.org/~mgorny/dist/${P}-patchset.tar.xz"

LICENSE="BSD"
SLOT="0"
IUSE="examples"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	dev-lang/tcl:0=
	dev-tcltk/tdom
	"
DEPEND="${RDEPEND}"

DOCS=( DESCRIPTION.txt STATUS )

S="${WORKDIR}"/${MY_P}

PATCHES=( "${WORKDIR}"/${P}-patchset/${P}-XSS-vuln.patch )

src_prepare() {
	has_version ">=dev-lang/tcl-8.6" && \
		PATCHES+=( "${WORKDIR}"/${P}-patchset/${P}-test.patch )
	epatch "${PATCHES[@]}"

	sed \
		-e '/testsNeedTcl/s:8.5:8.6:g' \
		-i modules/tar/tar.test || die
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
