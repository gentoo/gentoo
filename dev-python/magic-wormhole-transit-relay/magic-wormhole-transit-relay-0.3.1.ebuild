# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Transit relay server for magic-wormhole"
HOMEPAGE="
	https://magic-wormhole.readthedocs.io/en/latest/
	https://github.com/magic-wormhole/magic-wormhole-transit-relay/
	https://pypi.org/project/magic-wormhole-transit-relay/
"
SRC_URI="
	https://github.com/magic-wormhole/magic-wormhole-transit-relay/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/autobahn-21.3.1[${PYTHON_USEDEP}]
	>=dev-python/twisted-21.2.0[ssl,${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm versioneer.py || die
}

python_test() {
	local -x PATH=${T}/bin:${PATH}
	mkdir -p "${T}"/bin || die
	# the script is apparently run with PATH wiped, sigh
	cat > "${T}"/bin/twistd <<-EOF || die
		#!$(type -P python)
		import sys
		from twisted.scripts.twistd import run
		sys.exit(run())
	EOF
	chmod +x "${T}"/bin/twistd || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest

	find "${BUILD_DIR}/install" -name dropin.cache -delete || die
}

pkg_postinst() {
	python_foreach_impl twisted-regen-cache
}

pkg_postrm() {
	python_foreach_impl twisted-regen-cache
}
