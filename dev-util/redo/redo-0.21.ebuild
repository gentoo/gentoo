# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
inherit multilib python-single-r1

DESCRIPTION="Smaller, easier, more powerful, and more reliable than make"
HOMEPAGE="https://github.com/apenwarr/redo"
SRC_URI="${HOMEPAGE}/archive/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
DEPEND="
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/markdown[${PYTHON_USEDEP}]
"
S=${WORKDIR}/${PN}-${P}

src_install() {
	emake \
		DESTDIR="${D}" \
		DOCDIR="${D}/usr/share/doc/${PF}" \
		LIBDIR="${D}/usr/$(get_libdir)/${PN}" \
		install

	python_fix_shebang "${D}"

	sed -i \
		-e 's|/lib/|/'"$(get_libdir)"'/|g' \
		"${D}"/usr/bin/* || die
}
