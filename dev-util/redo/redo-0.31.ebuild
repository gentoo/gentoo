# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
inherit multilib multiprocessing python-single-r1

DESCRIPTION="Smaller, easier, more powerful, and more reliable than make"
HOMEPAGE="https://github.com/apenwarr/redo"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
BDEPEND="
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
"
S=${WORKDIR}/${PN}-${P}

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
