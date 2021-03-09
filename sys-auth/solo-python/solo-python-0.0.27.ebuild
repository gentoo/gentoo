# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

DISTUTILS_USE_SETUPTOOLS=pyproject.toml

inherit distutils-r1

DESCRIPTION="Python tool and library for SoloKeys"
HOMEPAGE="https://github.com/solokeys/solo-python"
SRC_URI="https://github.com/solokeys/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-python/click-7.0.0[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/ecdsa[${PYTHON_USEDEP}]
	>=dev-python/fido2-0.8.1[${PYTHON_USEDEP}]
	<dev-python/fido2-0.9.0[${PYTHON_USEDEP}]
	dev-python/intelhex[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]"

src_prepare() {
	# For some reason the version file gets omitted by src_install (a bug in pyproject2setuppy?),
	# and in any case there is no advantage to using one once a specific version has been released.
	sed -i -e "s/^__version__ = open(.\+$/__version__ = '${PV}'/" solo/__init__.py || die "Failed to set the version number"
	distutils-r1_src_prepare
}
