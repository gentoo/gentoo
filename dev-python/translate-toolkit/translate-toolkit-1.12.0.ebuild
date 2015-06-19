# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/translate-toolkit/translate-toolkit-1.12.0.ebuild,v 1.2 2015/04/16 09:27:57 jlec Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Toolkit to convert between many translation formats"
HOMEPAGE="http://translate.sourceforge.net"
SRC_URI="mirror://sourceforge/translate/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +html +ical +ini +subtitles"

RDEPEND="
	app-text/iso-codes
	sys-devel/gettext
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/python-levenshtein-0.10.2[${PYTHON_USEDEP}]
	!=dev-python/python-levenshtein-0.11.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/diff-match-patch[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	html? ( dev-python/utidylib[${PYTHON_USEDEP}] )
	ical? ( dev-python/vobject[${PYTHON_USEDEP}] )
	ini? ( dev-python/iniparse[${PYTHON_USEDEP}] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}"

python_prepare_all() {
	# Prevent unwanted d'loading in doc build
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( "${S}"/docs/_build/html/. )
	distutils-r1_python_install_all
	rm -Rf docs || die
}

python_install() {
	distutils-r1_python_install

	if ! use html; then
		rm "${ED}"/usr/bin/html2po || die
		rm "${ED}"/usr/bin/po2html || die
	fi
	if ! use ical; then
		rm "${ED}"/usr/bin/ical2po || die
		rm "${ED}"/usr/bin/po2ical || die
	fi
	if ! use ini; then
		rm "${ED}"/usr/bin/ini2po || die
		rm "${ED}"/usr/bin/po2ini || die
	fi
	if ! use subtitles; then
		rm "${ED}"/usr/bin/sub2po || die
		rm "${ED}"/usr/bin/po2sub || die
	fi
}
