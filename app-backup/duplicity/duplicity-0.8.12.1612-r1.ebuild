# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 )

inherit distutils-r1

DESCRIPTION="Secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="https://code.launchpad.net/${PN}/$(ver_cut 1-2)-series/$(ver_cut 1-3)/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="s3 test"

CDEPEND="
	net-libs/librsync
	app-crypt/gnupg
	dev-python/fasteners[${PYTHON_USEDEP}]
"
DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		app-arch/par2cmdline
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pexpect[${PYTHON_USEDEP}]
	)
"
RDEPEND="${CDEPEND}
	dev-python/paramiko[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	s3? ( dev-python/boto[${PYTHON_USEDEP}] )
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-fix-docs-cmd.patch"
)

python_test() {
	esetup.py test
}

pkg_postinst() {
	elog "Duplicity has many optional dependencies to support various backends."
	elog "Currently it's up to you to install them as necessary."
}
