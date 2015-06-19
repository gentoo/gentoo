# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/psycopg/psycopg-1.1.21.ebuild,v 1.25 2014/12/28 15:41:58 titanofold Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit python

DESCRIPTION="PostgreSQL database adapter for Python"
HOMEPAGE="http://www.initd.org/software/psycopg"
SRC_URI="http://initd.org/pub/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=dev-python/egenix-mx-base-2.0.3
	dev-db/postgresql"
RDEPEND="${DEPEND}"

src_prepare() {
	# fix for bug #134873
	sed -e '1245s/static //' -i cursor.c

	sed -e 's:$(PY_MOD_DIR):$(D)&/$$mod:' -i Makefile.pre.in

	python_copy_sources
}

src_configure() {
	configuration() {
		econf \
			--with-mxdatetime-includes="$(python_get_includedir)/mx" \
			--with-postgres-includes="/usr/include/postgresql/server" || return 1
		sed -e 's:$(BLDSHARED):& $(LDFLAGS):' -i Makefile
	}
	python_execute_function -s configuration
}

src_compile() {
	python_src_compile OPT="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install () {
	python_src_install

	dodoc AUTHORS ChangeLog CREDITS README NEWS RELEASE-1.0 SUCCESS TODO
	docinto doc
	dodoc doc/python-taylor.txt doc/README
	insinto /usr/share/doc/${PF}/examples
	doins doc/examples/*
}
