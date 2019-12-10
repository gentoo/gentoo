# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool

DESCRIPTION="YAML 1.1 parser and emitter written in C"
HOMEPAGE="https://github.com/yaml/libyaml"
SRC_URI="https://github.com/yaml/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default

	# conditionally remove tests
	if ! use test; then
		sed -i -e 's: tests::g' Makefile* || die
	fi

	elibtoolize  # for FreeMiNT
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_compile() {
	emake
	use doc && emake html
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	find "${D}" -name '*.la' -delete || die
}
