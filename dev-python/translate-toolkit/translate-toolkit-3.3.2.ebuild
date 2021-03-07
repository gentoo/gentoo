# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Toolkit to convert between many translation formats"
HOMEPAGE="https://github.com/translate/translate"
SRC_URI="https://github.com/translate/translate/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+html +ical +ini +subtitles +yaml"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND=">=dev-python/six-1.11.0[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}
	!dev-python/pydiff
	app-text/iso-codes
	>=dev-python/chardet-3.0.4[${PYTHON_USEDEP}]
	dev-python/cheroot[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.3.1[${PYTHON_USEDEP}]
	>=dev-python/pycountry-19.8.18[${PYTHON_USEDEP}]
	>=dev-python/python-levenshtein-0.12.0[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml[${PYTHON_USEDEP}]
	sys-devel/gettext
	html? ( dev-python/utidylib[${PYTHON_USEDEP}] )
	ical? ( dev-python/vobject[${PYTHON_USEDEP}] )
	ini? ( >=dev-python/iniparse-0.5[${PYTHON_USEDEP}] )
	subtitles? ( media-video/gaupol[${PYTHON_USEDEP}] )
	yaml? ( dev-python/pyyaml[${PYTHON_USEDEP}] )
"
BDEPEND+="
	test? ( dev-python/phply[${PYTHON_USEDEP}] )"

distutils_enable_sphinx docs \
	dev-python/sphinx-bootstrap-theme
distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/translate-toolkit-3.3.0-no-install-docs.patch
)

python_test() {
	local deselect=(
		# Fails with network-sandbox (and even with it off but w/ softer fail)
		--deselect 'tests/xliff_conformance/test_xliff_conformance.py::test_open_office_to_xliff'
		--deselect 'tests/xliff_conformance/test_xliff_conformance.py::test_po_to_xliff'
	)

	if ! use ini; then
		deselect+=(
			--ignore translate/convert/test_ini2po.py
			--ignore translate/convert/test_po2ini.py
		)
	fi

	if ! use subtitles; then
		deselect+=(
			--ignore translate/storage/test_subtitles.py
		)
	fi

	# translate/storage/test_mo.py needs 'pocompile'
	distutils_install_for_testing --via-root

	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
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
