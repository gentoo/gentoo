# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
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
KEYWORDS="amd64 arm64 x86"
IUSE="+html +ical +ini +subtitles +yaml"

RDEPEND="
	app-text/iso-codes
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	dev-python/cheroot[${PYTHON_USEDEP}]
	>=dev-python/Levenshtein-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/mistletoe-1.1.0[${PYTHON_USEDEP}]
	>=dev-python/pyparsing-3[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	sys-devel/gettext
	html? ( dev-python/utidylib[${PYTHON_USEDEP}] )
	ical? ( dev-python/vobject[${PYTHON_USEDEP}] )
	ini? ( >=dev-python/iniparse-0.5[${PYTHON_USEDEP}] )
	subtitles? ( media-video/gaupol[${PYTHON_USEDEP}] )
	yaml? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
"
# Technically, the test suite also has undeclared dependency
# on dev-python/snapshottest but all the tests using it are broken
# anyway, so we skip them.
BDEPEND="
	test? (
		dev-python/phply[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	# unfortunately, this bad quality package doesn't support XDG_DATA_DIRS
	# correctly, so we need to reassemble all data files in a single directory
	local -x XDG_DATA_HOME=${T}/share
	cp -r translate/share "${T}/" || die
	cp -r "${ESYSROOT}/usr/share"/gaupol "${XDG_DATA_HOME}"/ || die

	distutils-r1_src_test
}

python_test() {
	local EPYTEST_DESELECT=(
		# Fails with network-sandbox (and even with it off but w/ softer fail)
		'tests/xliff_conformance/test_xliff_conformance.py::test_open_office_to_xliff'
		'tests/xliff_conformance/test_xliff_conformance.py::test_po_to_xliff'
		# all tests based on snapshottest are broken and I'm too tired
		# to figure this out
		translate/tools/test_pocount.py::test_cases
		translate/tools/test_pocount.py::test_output
		translate/tools/test_junitmsgfmt.py::test_output
	)
	local EPYTEST_IGNORE=(
		# unpackaged fluent.*
		translate/storage/test_fluent.py
		# changes directory and does not change it back, sigh
		tests/odf_xliff/test_odf_xliff.py
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

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /usr
	doins -r translate/share

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
}
