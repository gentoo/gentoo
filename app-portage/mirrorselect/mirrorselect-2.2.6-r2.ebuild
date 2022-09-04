# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 prefix

DESCRIPTION="Tool to help select distfiles mirrors for Gentoo"
HOMEPAGE="https://wiki.gentoo.org/wiki/Mirrorselect"
SRC_URI="https://dev.gentoo.org/~zmedico/dist/${P}.tar.gz
	https://dev.gentoo.org/~dolsen/releases/mirrorselect/mirrorselect-test
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="ipv6"

RDEPEND="
	dev-util/dialog
	>=net-analyzer/netselect-0.4[ipv6(+)?]
	>=dev-python/ssl-fetch-0.3[${PYTHON_USEDEP}]
"

python_prepare_all() {
	python_setup
	eprefixify setup.py mirrorselect/main.py
	echo Now setting version... VERSION="${PVR}" "${PYTHON}" setup.py set_version
	VERSION="${PVR}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"
	if use ipv6; then
		# The netselect --ipv4 and --ipv6 options are supported only
		# with >=net-analyzer/netselect-0.4[ipv6(+)] (bug 688214).
		sed -e '/^NETSELECT_SUPPORTS_IPV4_IPV6 =/s|False|True|' \
			-i mirrorselect/selectors.py || die
	fi

	# Apply e69ec2d046626fa2079d460aab469d04256182cd for bug 698470.
	sed -e 's|key = lex.get_token()|\0\n\t\t\tif key is None:\n\t\t\t\tbreak|' -i mirrorselect/configs.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	esetup.py test || die "tests failed under ${EPYTHON}"
}
