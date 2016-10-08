# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="${PN/-toolkit}"
MY_PV="${PV/_beta/b}"
PYTHON_COMPAT=( python2_7 python3_{4,5} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

DESCRIPTION="Toolkit to convert between many translation formats"
HOMEPAGE="https://github.com/translate/translate"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc +html +ical +ini +subtitles"

COMMON_DEPEND="
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
"
DEPEND="${COMMON_DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
RDEPEND="${COMMON_DEPEND}
	app-text/iso-codes
	>=dev-python/chardet-2.3.0[${PYTHON_USEDEP}]
	dev-python/diff-match-patch[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.5[${PYTHON_USEDEP}]
	>=dev-python/python-levenshtein-0.12.0[${PYTHON_USEDEP}]
	sys-devel/gettext
	html? ( dev-python/utidylib[${PYTHON_USEDEP}] )
	ical? ( dev-python/vobject[${PYTHON_USEDEP}] )
	ini? ( dev-python/iniparse[${PYTHON_USEDEP}] )
	subtitles? ( $(python_gen_cond_dep 'media-video/gaupol[${PYTHON_USEDEP}]' python3_{4,5}) )
"

REQUIRED_USE="
	subtitles? ( || ( $(python_gen_useflags 'python3*') ) )
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

python_prepare_all() {
	# Prevent unwanted d'loading in doc build
	sed -e "/^    'sphinx.ext.intersphinx',/d" \
		-e "/html_theme/ s/sphinx-bootstrap/classic/" \
		-i docs/conf.py || die

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
		rm "${ED}"usr/bin/html2po || die
		rm "${ED}"usr/bin/po2html || die
	fi
	if ! use ical; then
		rm "${ED}"usr/bin/ical2po || die
		rm "${ED}"usr/bin/po2ical || die
	fi
	if ! use ini; then
		rm "${ED}"usr/bin/ini2po || die
		rm "${ED}"usr/bin/po2ini || die
	fi
	if ! use subtitles; then
		rm "${ED}"usr/bin/sub2po || die
		rm "${ED}"usr/bin/po2sub || die
	fi
}
