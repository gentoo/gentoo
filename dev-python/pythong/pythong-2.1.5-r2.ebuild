# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit python-single-r1

MY_PN="pythonG"
MY_PV=${PV/_/-}
MY_PV=${MY_PV//\./_}

DESCRIPTION="Nice and powerful spanish development environment for Python"
HOMEPAGE="http://www3.uji.es/~dllorens/PythonG/principal.html"
SRC_URI="
	http://www3.uji.es/~dllorens/downloads/pythong/linux/${MY_PN}-${MY_PV}.tgz
	doc? ( http://marmota.act.uji.es/MTP/pdf/python.pdf )"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 x86"
SLOT="0"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-lang/tk-8.3.4:0=
	dev-python/pmw:py2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_prepare() {
	sed \
		-e "s:^\(fullpath = \).*:\1'$(python_get_sitedir)':" \
		-e "/^url_docFuncPG/s:'+fullpath+':/usr/share/doc/${PF}:" \
		-i pythong.py || die "sed in pythong.py failed"
}

src_install() {
	python_domodule modulepythong.py libpythong
	python_doscript pythong.py

	dodoc leeme.txt
	insinto /usr/share/doc/${PF}
	doins -r {LICENCIA,MANUAL,demos}
	rm -fr "${ED}/usr/share/doc/${PF}/demos/modulepythong.py" || die

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/python.pdf
	fi
	python_optimize
}
