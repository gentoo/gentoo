# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

MY_P=translate-${PV}
DESCRIPTION="Toolkit to convert between many translation formats"
HOMEPAGE="
	https://github.com/translate/translate/
	https://pypi.org/project/translate-toolkit/
"
SRC_URI="
	https://github.com/translate/translate/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+html +ical +ini +subtitles +yaml"

RDEPEND="
	app-text/iso-codes
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	dev-python/cheroot[${PYTHON_USEDEP}]
	>=dev-python/Levenshtein-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/pycountry-19.8.18[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	sys-devel/gettext
	html? ( dev-python/utidylib[${PYTHON_USEDEP}] )
	ical? ( dev-python/vobject[${PYTHON_USEDEP}] )
	ini? ( >=dev-python/iniparse-0.5[${PYTHON_USEDEP}] )
	subtitles? ( media-video/gaupol[${PYTHON_USEDEP}] )
	yaml? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
"
BDEPEND="
	test? ( dev-python/phply[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx docs \
	dev-python/sphinx-bootstrap-theme
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Fails with network-sandbox (and even with it off but w/ softer fail)
		'tests/xliff_conformance/test_xliff_conformance.py::test_open_office_to_xliff'
		'tests/xliff_conformance/test_xliff_conformance.py::test_po_to_xliff'
	)
	local EPYTEST_IGNORE=(
		# unpackaged fluent.*
		translate/storage/test_fluent.py
	)

	if ! use ini; then
		EPYTEST_IGNORE+=(
			translate/convert/test_ini2po.py
			translate/convert/test_po2ini.py
		)
	fi

	if ! use subtitles; then
		EPYTEST_IGNORE+=(
			translate/storage/test_subtitles.py
		)
	fi

	# translate/storage/test_mo.py needs 'pocompile'
	distutils_install_for_testing
	epytest
}

python_install_all() {
	distutils-r1_python_install_all

	if ! use html; then
		rm "${ED}"/usr/bin/{html2po,po2html} || die
	fi
	if ! use ical; then
		rm "${ED}"/usr/bin/{ical2po,po2ical} || die
	fi
	if ! use ini; then
		rm "${ED}"/usr/bin/{ini2po,po2ini} || die
	fi
	if ! use subtitles; then
		rm "${ED}"/usr/bin/{sub2po,po2sub} || die
	fi

	python_optimize
}
