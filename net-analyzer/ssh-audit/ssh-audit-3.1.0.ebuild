# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=(python3_{10,11,12})

inherit distutils-r1

DESCRIPTION="SSH server auditing (banner, key exchange, encryption, mac, compression, etc)"
HOMEPAGE="https://github.com/jtesta/ssh-audit"
SRC_URI="https://github.com/jtesta/ssh-audit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64"
IUSE=""

# Tests require prospector which is not packaged
RESTRICT="test"

src_install() {
	distutils-r1_src_install

	doman ssh-audit.1
}
