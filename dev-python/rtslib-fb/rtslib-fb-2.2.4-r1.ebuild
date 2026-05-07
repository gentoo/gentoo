# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/open-iscsi/rtslib-fb
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 systemd pypi

DESCRIPTION="A Python object API for managing the Linux LIO kernel target"
HOMEPAGE="
	https://github.com/open-iscsi/rtslib-fb/
	https://pypi.org/project/rtslib-fb/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/pyudev[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

distutils_enable_tests import-check

python_compile() {
	distutils-r1_python_compile

	# workaround broken upstream hack
	# https://github.com/open-iscsi/rtslib-fb/issues/229
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	ln -s rtslib rtslib_fb || die
}

src_install() {
	distutils-r1_src_install
	systemd_dounit "${FILESDIR}/target.service"
}
