# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Flash firmware to devices running Microchip's 16-bit bootloader"
HOMEPAGE="
	https://pypi.org/project/mcbootflash/
	https://github.com/bessman/mcbootflash/
"
SRC_URI+="
	https://github.com/bessman/mcbootflash/raw/eb940f0324eb0c6822a0feca48449f5191cf5a00/tests/test_mcbootflash.jsonl
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="
	>=dev-python/bincopy-20.0.0[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-reserial[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_unpack() {
	default
	# sigh, pytest-reserial arbitrarily changed output format
	# without caring for backwards compatibility
	cp "${DISTDIR}"/test_mcbootflash.jsonl "${S}"/tests/ || die
}

python_test() {
	epytest --replay
}
