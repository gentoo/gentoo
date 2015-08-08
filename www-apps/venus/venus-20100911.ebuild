# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"

inherit webapp python

WEBAPP_MANUAL_SLOT="yes"

DESCRIPTION="A feed aggregator application"
HOMEPAGE="http://intertwingly.net/code/venus/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="PSF-2.2"
KEYWORDS="~amd64 ~x86"
IUSE="django genshi redland test"
SLOT="0"

DEPEND="
		test? ( =dev-lang/python-2*[berkdb] )
		"
RDEPEND="django? ( dev-python/django )
		genshi? ( dev-python/genshi )
		redland? ( dev-python/rdflib[redland] )
		dev-python/chardet
		dev-python/httplib2
		dev-python/utidylib
"
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}"/${PN}

src_prepare() {
	python_convert_shebangs -r 2 .
}

src_test() {
	testing() {
		PYTHONPATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" runtests.py
	}
	python_execute_function testing
}

src_install() {
	webapp_src_preinst

	dodoc AUTHORS README TODO
	dohtml -r docs/*

	installation() {
		insinto "$(python_get_sitedir)/${PN}"
		doins -r *py {filters,planet}
	}
	python_execute_function installation

	insinto "${MY_APPDIR}"
	doins -r themes

	insinto "${MY_HOSTROOTDIR}/conf"
	doins -r examples

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}

pkg_postinst() {
	python_mod_optimize venus
	webapp_pkg_postinst
	elog "Installation instructions can be found at /usr/share/doc/${PF}/html/
		or http://intertwingly.net/code/venus/docs/index.html"
}

pkg_postrm() {
	python_mod_cleanup venus
}
