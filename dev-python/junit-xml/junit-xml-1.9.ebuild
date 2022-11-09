# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1

DESCRIPTION="Create JUnit XML test result documents"
HOMEPAGE="
	https://pypi.org/project/junit-xml/
	https://github.com/kyrus/python-junit-xml"
# upstream fails both at uploading to pypi and making tags
# https://github.com/kyrus/python-junit-xml/issues/69
# https://github.com/kyrus/python-junit-xml/issues/31
EGIT_COMMIT="19d3cc333d35dfd2d17d75c506336c15e5c6685a"
SRC_URI="
	https://github.com/kyrus/python-junit-xml/archive/${EGIT_COMMIT}.tar.gz
		-> ${P}.tar.gz"
S=${WORKDIR}/python-junit-xml-${EGIT_COMMIT}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
