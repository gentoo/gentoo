# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN=py-metadata

DESCRIPTION="Python bindings for the Linode Metadata Service"
HOMEPAGE="https://github.com/linode/py-metadata https://www.linode.com/"
SRC_URI="https://github.com/linode/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/httpx[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	default

	# require network and do not work
	rm -r test/integration || die

	emake create-version LINODE_METADATA_VERSION=${PV}
}
