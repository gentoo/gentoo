# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit python-single-r1

DESCRIPTION="A text-based calendar and scheduling application"
HOMEPAGE="https://calcurse.org/"
SRC_URI="https://calcurse.org/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc ppc64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="caldav doc"

RDEPEND="
	sys-libs/ncurses:0=
	${PYTHON_DEPS}
	caldav? (
		$(python_gen_cond_dep '
			dev-python/httplib2[${PYTHON_USEDEP}]
			dev-python/pyparsing[${PYTHON_USEDEP}]
		')
	)
"

DEPEND="
	${RDEPEND}
"

src_configure() {
	local myconf=(
		$(use_enable doc docs)
		--without-asciidoc # do not use AsciiDoc to regenerate docs
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

src_compile() {
	default
	python_fix_shebang contrib/caldav/calcurse-caldav
}

src_install() {
	docompress -x /usr/share/doc # decompress text files
	default
}
