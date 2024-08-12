# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit bash-completion-r1 distutils-r1 pypi

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
	dev-python/six[${PYTHON_USEDEP}]
	~dev-python/spake2-0.8[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.13.0[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
	>=dev-python/txtorcon-18.0.2[${PYTHON_USEDEP}]
	>=dev-python/zipstream-ng-1.7.1[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/magic-wormhole-mailbox-server[${PYTHON_USEDEP}]
		~dev-python/magic-wormhole-transit-relay-0.2.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm versioneer.py || die
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}

src_install() {
	distutils-r1_src_install

	newbashcomp "${ED}/usr/wormhole_complete.bash" wormhole
	insinto /usr/share/fish/completions
	newins "${ED}/usr/wormhole_complete.fish" wormhole.fish
	insinto /usr/share/zsh/site-functions
	newins "${ED}/usr/wormhole_complete.zsh" _wormhole
	rm "${ED}/usr"/wormhole_complete* || die
}
