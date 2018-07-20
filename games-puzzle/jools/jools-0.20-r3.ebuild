# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1

MUS_P="${PN}-musicpack-1.0"
DESCRIPTION="clone of Bejeweled, a popular pattern-matching game"
HOMEPAGE="http://pessimization.com/software/jools/"
SRC_URI="http://pessimization.com/software/jools/${P}.tar.gz
	 http://pessimization.com/software/jools/${MUS_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	dev-python/pygame[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}/jools"

src_unpack() {
	unpack ${P}.tar.gz
	cd "${S}"/music
	unpack ${MUS_P}.tar.gz
}

src_prepare() {
	default
	echo "MEDIAROOT = \"/usr/share/${PN}\"" > config.py
	python_fix_shebang .
}

src_install() {
	make_wrapper ${PN} "${EPYTHON} ./__init__.py" /usr/"$(get_libdir)"/${PN}
	insinto /usr/"$(get_libdir)"/${PN}
	doins *.py
	python_optimize "${ED}/usr/$(get_libdir)/${PN}"

	insinto /usr/share/${PN}
	doins -r fonts images music sounds

	newicon images/ruby/0001.png ${PN}.png
	make_desktop_entry ${PN} Jools

	dodoc ../{ChangeLog,doc/{POINTS,TODO}}
	HTML_DOCS="../doc/manual.html" einstalldocs
}
