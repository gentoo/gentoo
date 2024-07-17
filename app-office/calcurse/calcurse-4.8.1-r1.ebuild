# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1

DESCRIPTION="A text-based calendar and scheduling application"
HOMEPAGE="https://calcurse.org/"
SRC_URI="https://calcurse.org/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ppc ppc64 x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
IUSE="caldav doc"

RDEPEND="
	sys-libs/ncurses:0=
	sys-libs/timezone-data
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

BDEPEND="virtual/pkgconfig"

src_configure() {
	local myconf=(
		$(use_enable doc docs)
		--without-asciidoc # do not use AsciiDoc to regenerate docs
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

src_compile() {
	default
	if use caldav; then
		python_fix_shebang contrib/caldav/calcurse-caldav
	fi
}

src_install() {
	docompress -x /usr/share/doc # decompress text files
	default
}
