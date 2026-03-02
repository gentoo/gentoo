# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )
inherit distutils-r1 optfeature

MY_P="${PN}.six-${PV}"
DESCRIPTION="Python tool for extracting information from PDF documents"
HOMEPAGE="https://pdfminersix.readthedocs.io/en/latest/"
# Release tarballs lack tests
SRC_URI="https://github.com/pdfminer/pdfminer.six/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/charset-normalizer-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/cryptography-36.0.0[${PYTHON_USEDEP}]
"
BDEPEND="dev-python/setuptools-scm[${PYTHON_USEDEP}]"

EPYTEST_PLUGINS=()

distutils_enable_sphinx docs/source "dev-python/sphinx-argparse"
distutils_enable_tests pytest

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

pkg_postinst() {
	optfeature "export to JPEG support" dev-python/pillow
}
