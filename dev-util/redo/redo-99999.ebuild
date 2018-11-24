# Copyright 2018 Gentoo Authors
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
BDEPEND="
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
"

src_compile() {
	./redo -j$(makeopts_jobs) || die
}

src_test() {
	./redo -j$(makeopts_jobs) test || die
}

src_install() {
	DESTDIR="${D}" \
	DOCDIR="${D}/usr/share/doc/${PF}" \
	LIBDIR="${D}/usr/$(get_libdir)/${PN}" \
	./redo -j$(makeopts_jobs) \
		install || die

	python_fix_shebang "${D}"

	sed -i \
		-e 's|/lib/|/'"$(get_libdir)"'/|g' \
		"${D}"/usr/bin/* || die
}
