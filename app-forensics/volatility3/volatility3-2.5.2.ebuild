# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

MY_PV=${PV//_beta/-beta.}

DESCRIPTION="Framework for analyzing volatile memory"
HOMEPAGE="https://github.com/volatilityfoundation/volatility3/ https://www.volatilityfoundation.org/"
SRC_URI="
	https://github.com/volatilityfoundation/volatility3/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz
	test?
	(
		https://downloads.volatilityfoundation.org/volatility3/images/win-xp-laptop-2005-06-25.img.gz -> ${PN}-win-xp-laptop-2005-06-25.img.gz
		https://downloads.volatilityfoundation.org/volatility3/images/linux-sample-1.bin.gz -> ${PN}-linux-sample-1.bin.gz
	)
"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt disasm jsonschema leechcore snappy test yara"

# We need to select *all* subslots of app-arch/snappy which select
# SONAME=libsnappy.so.1. See (https://github.com/gentoo/gentoo/pull/30585#discussion_r1167753625)
RDEPEND="
	>=dev-python/pefile-2023.2.7[${PYTHON_USEDEP}]
	crypt? ( >=dev-python/pycryptodome-3[${PYTHON_USEDEP}] )
	disasm? ( >=dev-libs/capstone-3.0.5[python,${PYTHON_USEDEP}] )
	jsonschema? ( >=dev-python/jsonschema-2.3.0[${PYTHON_USEDEP}] )
	leechcore? ( >=dev-python/leechcorepyc-2.4.0[${PYTHON_USEDEP}] )
	snappy? (
		|| (
			app-arch/snappy:0/1
			app-arch/snappy:0/1.1
		)
	)
	yara? ( >=dev-python/yara-python-3.8.0[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}"

# Tests require optional features
REQUIRED_USE="test? ( yara )"

RESTRICT="!test? ( test )"

python_test() {
	# see .github/workflows/test.yaml
	"${EPYTHON}" "${S}/test/test_volatility.py" --volatility=vol.py \
		--image "${WORKDIR}/${PN}-win-xp-laptop-2005-06-25.img" -k test_windows -v || \
		die "Tests fail with ${EPYTHON}"
	"${EPYTHON}" "${S}/test/test_volatility.py" --volatility=vol.py \
		--image "${WORKDIR}/${PN}-linux-sample-1.bin" -k test_linux -v || \
		die "Tests fail with ${EPYTHON}"
}
