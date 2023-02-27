# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Utility to securely retrieve an SSH public key and install it locally"
HOMEPAGE="https://launchpad.net/ssh-import-id"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="
	dev-python/distro[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install
	doman usr/share/man/man1/ssh-import-id.1
}
