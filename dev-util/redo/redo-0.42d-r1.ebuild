# Copyright 2018-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
PYTHON_REQ_USE="sqlite"

inherit edo multiprocessing python-single-r1

DESCRIPTION="Smaller, easier, more powerful, and more reliable than make"
HOMEPAGE="https://github.com/apenwarr/redo"
SRC_URI="https://github.com/apenwarr/redo/archive/${P}.tar.gz"
S="${WORKDIR}"/${PN}-${P}

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
	')
	${PYTHON_DEPS}
"
RDEPEND="${BDEPEND}"

src_prepare() {
	default

	sed -i -e "s:which:command -v:" redo/sh.do || die
	sed -i "1s;^;#!${PYTHON}\n;" docs/md2man.py || die
}

src_configure() {
	echo ${PYTHON} > redo/whichpython || die
}

src_compile() {
	edo ./do -j$(makeopts_jobs) build
}

src_test() {
	local ARCH= CFLAGS= CXXFLAGS= LDFLAGS=
	edo ./do -j$(makeopts_jobs) test
}

src_install() {
	DESTDIR="${D}" \
	DOCDIR="${D}/usr/share/doc/${PF}" \
	LIBDIR="${D}/$(python_get_sitedir)/${PN}" \
	edo ./do -j$(makeopts_jobs) \
		install

	python_fix_shebang "${D}"

	sed -i \
		-e 's|/lib/|/'"$(get_libdir)"'/|g' \
		"${D}"/usr/bin/* || die

	python_optimize
}
