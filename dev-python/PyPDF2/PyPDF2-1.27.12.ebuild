# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

SAMPLE_COMMIT=41b5cd4f774f8fbd8ac42d93b9962f0376352a15
DESCRIPTION="Python library to work with PDF files"
HOMEPAGE="
	https://pypi.org/project/PyPDF2/
	https://github.com/py-pdf/PyPDF2/
"
SRC_URI="
	https://github.com/py-pdf/PyPDF2/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	test? (
		https://github.com/py-pdf/sample-files/archive/${SAMPLE_COMMIT}.tar.gz
			-> ${PN}-sample-files-${SAMPLE_COMMIT}.tar.gz
	)
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 x86"
IUSE="examples"

BDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

src_unpack() {
	default
	if use test; then
		mv "sample-files-${SAMPLE_COMMIT}"/* "${P}"/sample-files/ || die
	fi
}

src_install() {
	if use examples; then
		docinto examples
		dodoc -r Sample_Code/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_src_install
}
