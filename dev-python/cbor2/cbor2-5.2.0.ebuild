# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Pure Python CBOR (de)serializer with extensive tag support"
HOMEPAGE="https://github.com/agronholm/cbor2 https://pypi.org/project/cbor2/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"

distutils_enable_tests pytest

python_prepare_all() {
	# remove pytest-cov dep
	sed -e "s/pytest-cov//" \
		-e "s/--cov //" \
		-i setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	local deselect=()

	if use arm || use x86; then
		# https://github.com/agronholm/cbor2/issues/99
		deselect+=(
			tests/test_decoder.py::test_huge_truncated_bytes
			tests/test_decoder.py::test_huge_truncated_string
		)
	fi

	epytest ${deselect[@]/#/--deselect }
}
