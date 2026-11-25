# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/python-babel/babel
PYTHON_COMPAT=( python3_{12..15} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1 locale-utils pypi

# see scripts/download_import_cldr.py
CLDR_PV=49
DESCRIPTION="Collection of tools for internationalizing Python applications"
HOMEPAGE="
	https://babel.pocoo.org/
	https://pypi.org/project/babel/
	https://github.com/python-babel/babel/
"
SRC_URI+="
	https://unicode.org/Public/cldr/${CLDR_PV%.*}/cldr-common-${CLDR_PV}.zip
	https://unicode.org/Public/cldr/${CLDR_PV%.*}/cldr-exemplars-delta-${CLDR_PV}.zip
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

BDEPEND="
	app-arch/unzip
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs
EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_unpack() {
	pypi_src_unpack

	# TODO: skip unpacking them? upstream does selective unpack,
	# and misbehaves when we unpack too much.
	rm -r "${WORKDIR}/common" || die
	mkdir "${S}/cldr" || die
	cp "${DISTDIR}"/cldr-{common,exemplars-delta}-${CLDR_PV}.zip \
		"${S}/cldr/" || die
}

src_prepare() {
	rm babel/locale-data/*.dat || die
	rm babel/global.dat || die
	distutils-r1_src_prepare
}

python_configure() {
	if [[ ! -f babel/global.dat ]]; then
		"${EPYTHON}" scripts/download_import_cldr.py || die
	fi
}

src_test() {
	local EPYTEST_DESELECT=()

	elocale_gen fr_FR.UTF-8 || EPYTEST_DESELECT+=(
		tests/messages/test_setuptools_frontend.py::test_setuptools_commands
	)

	local -x TZ=UTC
	unset LC_MESSAGES LC_ALL
	distutils-r1_src_test
}
