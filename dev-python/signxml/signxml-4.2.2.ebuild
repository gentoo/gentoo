# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Python XML Signature and XAdES library"
HOMEPAGE="
	https://pypi.org/project/signxml/
	https://github.com/XML-Security/signxml
"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/XML-Security/signxml.git"
else
	inherit pypi
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="
	>=dev-python/lxml-5[${PYTHON_USEDEP}]
	<dev-python/lxml-7[${PYTHON_USEDEP}]
	>=dev-python/cryptography-43[${PYTHON_USEDEP}]
	>=dev-python/certifi-2023.11.17[${PYTHON_USEDEP}]
"

RESTRICT="!test? ( test )"

python_test() {
	"${EPYTHON}" test/test.py -v || die
}
