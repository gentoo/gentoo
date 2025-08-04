# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi shell-completion

DESCRIPTION="Get Things From One Computer To Another, Safely"
HOMEPAGE="
	https://magic-wormhole.readthedocs.io/en/latest/
	https://github.com/magic-wormhole/magic-wormhole/
	https://pypi.org/project/magic-wormhole/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/attrs-19.2.0[${PYTHON_USEDEP}]
	>=dev-python/autobahn-0.14.1[${PYTHON_USEDEP}]
	dev-python/automat[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	>=dev-python/iterable-io-1.0.0[${PYTHON_USEDEP}]
	dev-python/noiseprotocol[${PYTHON_USEDEP}]
	dev-python/pynacl[${PYTHON_USEDEP}]
	>=dev-python/qrcode-8.0[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	~dev-python/spake2-0.9[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.13.0[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
	>=dev-python/txtorcon-18.0.2[${PYTHON_USEDEP}]
	>=dev-python/zipstream-ng-1.7.1[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/magic-wormhole-mailbox-server[${PYTHON_USEDEP}]
		dev-python/magic-wormhole-transit-relay[${PYTHON_USEDEP}]
		dev-python/pytest-twisted[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm versioneer.py || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p pytest_twisted
}

src_install() {
	distutils-r1_src_install

	newbashcomp "${ED}/usr/wormhole_complete.bash" wormhole
	newfishcomp "${ED}/usr/wormhole_complete.fish" wormhole.fish
	newzshcomp "${ED}/usr/wormhole_complete.zsh" _wormhole
	rm "${ED}/usr"/wormhole_complete* || die
}
