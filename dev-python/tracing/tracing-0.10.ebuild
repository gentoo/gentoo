# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Debug log/trace messages"
HOMEPAGE="https://liw.fi/tracing/"
SRC_URI="http://git.liw.fi/cgi-bin/cgit/cgit.cgi/python-tracing/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND="doc? ( dev-python/sphinx )"

python_compile_all() {
	if use doc; then
		emake -C doc html
		HTML_DOCS=( doc/_build/html/. )
		rm -rf doc/_build/html/{objects.inv,_sources} || die
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc example.py
		docompress -x /usr/share/doc/${PF}/examples/
	fi
}
