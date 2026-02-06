# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

MY_PV=${PV//_beta/-beta.}

DESCRIPTION="Framework for analyzing volatile memory"
HOMEPAGE="https://github.com/volatilityfoundation/volatility3/ https://www.volatilityfoundation.org/"
SRC_URI="
	https://github.com/volatilityfoundation/volatility3/archive/v${MY_PV}.tar.gz -> ${P}.gh.tar.gz
	https://downloads.volatilityfoundation.org/volatility3/symbols/linux.zip -> ${P}-symbols-linux.zip
	https://downloads.volatilityfoundation.org/volatility3/symbols/mac.zip -> ${P}-symbols-mac.zip
	https://downloads.volatilityfoundation.org/volatility3/symbols/windows.zip -> ${P}-symbols-windows.zip
	test?
	(
		https://downloads.volatilityfoundation.org/volatility3/images/linux-sample-1.bin.gz -> ${PN}-linux-sample-1.bin.gz
		https://downloads.volatilityfoundation.org/volatility3/images/win-xp-laptop-2005-06-25.img.gz -> ${PN}-win-xp-laptop-2005-06-25.img.gz
		https://downloads.volatilityfoundation.org/volatility3/images/win-10_19041-2025_03.dmp.gz -> ${PN}-win-10_19041-2025_03.dmp.gz
		https://downloads.volatilityfoundation.org/volatility3/symbols/symbols_win-10_19041-2025_03.zip -> ${PN}-symbols-symbols_win-10_19041-2025_03.zip
	)
"
S="${WORKDIR}"/${PN}-${MY_PV}

LICENSE="Volatility-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="crypt disasm jsonschema leechcore snappy test yara"

# We need to select *all* subslots of app-arch/snappy which select
# SONAME=libsnappy.so.1. See (https://github.com/gentoo/gentoo/pull/30585#discussion_r1167753625)
RDEPEND="
	>=dev-python/pefile-2024.8.26[${PYTHON_USEDEP}]
	crypt? ( >=dev-python/pycryptodome-3.21.0[${PYTHON_USEDEP}] )
	disasm? (
		>=dev-libs/capstone-5.0.3[python,${PYTHON_USEDEP}]
		<dev-libs/capstone-6[python,${PYTHON_USEDEP}]
	)
	jsonschema? ( >=dev-python/jsonschema-4.23.0[${PYTHON_USEDEP}] )
	leechcore? ( >=dev-python/leechcorepyc-2.19.2[${PYTHON_USEDEP}] )
	snappy? ( app-arch/snappy:0/1.1 )
	yara? (
		|| (
			>=app-forensics/yara-x-0.10.0[${PYTHON_USEDEP}]
			>=dev-python/yara-python-4.5.0[${PYTHON_USEDEP}]
		)
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
"

# Tests require optional features
REQUIRED_USE="test? ( yara )"

RESTRICT="!test? ( test )"

distutils_enable_tests pytest

src_prepare() {
	default

	mv "${WORKDIR}/linux" "${S}/${PN}/symbols" || die
	mv "${WORKDIR}"/*.dmg.json.xz "${S}/${PN}/symbols" || die
	mv "${WORKDIR}/windows" "${S}/${PN}/symbols" || die

	if use test; then
		# tests want the images in a common directory
		mkdir "${T}/test_images" || die
		mv "${WORKDIR}/${PN}-linux-sample-1.bin" "${T}/test_images/linux-sample-1.bin" || die
		mv "${WORKDIR}/${PN}-win-xp-laptop-2005-06-25.img" "${T}/test_images/win-xp-laptop-2005-06-25.img" || die
		mv "${WORKDIR}/${PN}-win-10_19041-2025_03.dmp" "${T}/test_images/win-10_19041-2025_03.dmp" || die
		mv "${WORKDIR}/167FE94B5641C005AC3036212A01F8DC-1.json" "${S}/${PN}/symbols" || die
	fi
}

python_test() {
	# see .github/workflows/test.yaml
	epytest "${S}/test/plugins/windows/windows.py" \
		--volatility=volshell.py \
		--image-dir "${T}/test_images" \
		-k test_windows_volshell -v
	epytest "${S}/test/plugins/linux/linux.py" \
		--volatility=volshell.py \
		--image-dir "${T}/test_images" \
		-k test_linux_volshell -v

	# unable to get tests working
	# epytest "${S}/test/plugins/windows/windows.py" \
	# 	--volatility=vol.py \
	# 	--image "${T}/test_images/win-10_19041-2025_03.dmp" \
	# 	-k "test_windows and not test_windows_volshell" -v --durations=0
	# epytest "${S}/test/plugins/linux/linux.py" \
	# 	--volatility=vol.py \
	# 	--image-dir "${T}/test_images" \
	# 	-k "test_linux and not test_linux_volshell" -v
}
