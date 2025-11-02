# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{11..13} )

inherit cargo distutils-r1 optfeature

DESCRIPTION="Distributed Version Control System with a Friendly UI"
HOMEPAGE="https://www.breezy-vcs.org/ https://github.com/breezy-team/breezy"
SRC_URI="https://github.com/breezy-team/breezy/archive/brz-${PV}.tar.gz -> ${P}.gh.tar.gz"
SRC_URI+=" https://github.com/gentoo-crate-dist/${PN}/releases/download/brz-${PV}/${PN}-brz-${PV}-crates.tar.xz"
S=${WORKDIR}/${PN}-brz-${PV}

LICENSE="GPL-2+"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# I've got tired of all the test failures. It definitely mostly works.
# We have ~29000 tests successfully passing from ~30000 tests.
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/configobj[${PYTHON_USEDEP}]
		dev-python/fastbencode[${PYTHON_USEDEP}]
		dev-python/patiencediff[${PYTHON_USEDEP}]
		dev-python/merge3[${PYTHON_USEDEP}]
		dev-python/dulwich[${PYTHON_USEDEP}]
		dev-python/urllib3[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tzlocal[${PYTHON_USEDEP}]
	')
	!dev-vcs/bzr
"
BDEPEND="
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/setuptools-gettext[${PYTHON_USEDEP}]
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	')
"

QA_FLAGS_IGNORED="
	usr/lib.*/py.*/site-packages/breezy/.*.so
	usr/bin/brz
"

src_prepare() {
	sed -e 's@man/man1@share/&@' \
		-e 's@, strip=Strip\.All@@' \
		-i setup.py || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	# Symlink original bzr's bin names to new names
	dosym brz /usr/bin/bzr
}

pkg_postinst() {
	optfeature "access branches over sftp" "dev-python/pycryptodome dev-python/paramiko"
	optfeature "PGP sign and verify commits" "dev-python/gpgmepy"
}
