# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit autotools-utils python-r1

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="http://www.initd.org/software/psycopg"
SRC_URI="http://initd.org/pub/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="examples"

RDEPEND=">=dev-python/egenix-mx-base-2.0.3[${PYTHON_USEDEP}]
	dev-db/postgresql
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	# fix for bug #134873
	sed -e '1245s/static //' -i cursor.c || die
	sed -e 's:$(PY_MOD_DIR):$(D)&/$$mod:' \
		-e '/^CFLAGS/s:-I:-I. &:' \
		-i Makefile.pre.in || die

	autotools-utils_src_prepare
}

src_configure() {
	python_configure() {
		local myeconfargs=(
			--with-mxdatetime-includes="$(python_get_includedir)/mx"
			--with-postgres-includes="/usr/include/postgresql/server"
		)

		autotools-utils_src_configure

		sed -e 's:$(BLDSHARED):& $(LDFLAGS):' \
			-i "${BUILD_DIR}"/Makefile || die
	}
	python_foreach_impl python_configure
}

src_compile() {
	python_foreach_impl autotools-utils_src_compile \
		OPT="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_test() {
	:
}

src_install () {
	python_install() {
		dodir "$(python_get_sitedir)"
		autotools-utils_src_install
	}

	python_foreach_impl python_install

	dodoc RELEASE-1.0 SUCCESS doc/python-taylor.txt

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r doc/examples/.
		docompress -x "${INSDESTTREE}"
	fi
}
