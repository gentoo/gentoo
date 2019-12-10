# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit webapp python-single-r1

WEBAPP_MANUAL_SLOT="yes"

DESCRIPTION="A feed aggregator application"
HOMEPAGE="http://intertwingly.net/code/venus/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="PSF-2.2"
KEYWORDS="~amd64 ~x86"
IUSE="django genshi redland test"
RESTRICT="!test? ( test )"
SLOT="0"

RDEPEND="
	dev-python/bsddb3[${PYTHON_USEDEP}]
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	dev-python/utidylib[${PYTHON_USEDEP}]
	django? ( dev-python/django[${PYTHON_USEDEP}] )
	genshi? ( dev-python/genshi[${PYTHON_USEDEP}] )
	redland? ( dev-python/rdflib[redland,${PYTHON_USEDEP}] )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S="${WORKDIR}"/${PN}

pkg_setup() {
	python-single-r1_pkg_setup
	webapp_pkg_setup
}

PATCHES=(
	"${FILESDIR}"/venus-bsddb3.patch
	"${FILESDIR}"/venus-xml-utf8.patch
)

src_prepare() {
	default_src_prepare
	python_fix_shebang .
}

src_test() {
	"${PYTHON}" runtests.py || die
}

src_install() {
	webapp_src_preinst

	dodoc AUTHORS README TODO
	dodoc -r docs

	python_moduleinto venus
	python_domodule *.py filters planet

	insinto "${MY_APPDIR}"
	doins -r themes

	insinto "${MY_HOSTROOTDIR}/conf"
	doins -r examples

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
	elog "Installation instructions can be found at /usr/share/doc/${PF}/html/
		or http://intertwingly.net/code/venus/docs/index.html"
}
