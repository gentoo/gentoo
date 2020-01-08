# Copyright 2018-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
inherit git-r3 multilib multiprocessing python-single-r1

DESCRIPTION="Smaller, easier, more powerful, and more reliable than make"
HOMEPAGE="https://github.com/apenwarr/redo"
EGIT_REPO_URI="${HOMEPAGE}"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

BDEPEND="
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
	${PYTHON_DEPS}
"
RDEPEND="
	${BDEPEND}
"

src_compile() {
	./do -j$(makeopts_jobs) build || die
}

src_test() {
	local ARCH= CFLAGS= CXXFLAGS= LDFLAGS=
	./do -j$(makeopts_jobs) test || die
}

src_install() {
	DESTDIR="${D}" \
	DOCDIR="${D}/usr/share/doc/${PF}" \
	LIBDIR="${D}/usr/$(get_libdir)/${PN}" \
	./do -j$(makeopts_jobs) \
		install || die

	python_fix_shebang "${D}"

	sed -i \
		-e 's|/lib/|/'"$(get_libdir)"'/|g' \
		"${D}"/usr/bin/* || die
}
