# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit libtool

MY_P="${P/lib}"

DESCRIPTION="YAML 1.1 parser and emitter written in C"
HOMEPAGE="http://pyyaml.org/wiki/LibYAML"
SRC_URI="http://pyyaml.org/download/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"

S="${WORKDIR}/${MY_P}"
PATCHES=(
	"${FILESDIR}/${PN}-0.1.7-mingw-no-undefined.patch"
)

src_prepare() {
	default

	# conditionally remove tests
	if ! use test; then
		sed -i -e 's: tests::g' Makefile* || die
	fi

	elibtoolize  # for FreeMiNT
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default

	find "${D}" -name '*.la' -delete || die

	docinto examples
	dodoc tests/example-*.c
	docompress -x /usr/share/doc/${PF}/examples
}
