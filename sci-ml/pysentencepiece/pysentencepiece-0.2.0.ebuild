# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

MY_PN=${PN:2}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Text tokenizer for Neural Network-based text generation"
HOMEPAGE="https://github.com/google/sentencepiece"
SRC_URI="https://github.com/google/${MY_PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${MY_P}.tar.gz"

S="${WORKDIR}"/${MY_P}/python

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${CATEGORY}/${MY_PN}"
DEPEND="${RDEPEND}"

python_test() {
	${EPYTHON} test/sentencepiece_test.py || die
}
