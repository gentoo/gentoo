# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 bash-completion-r1

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/${PN}/borg.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	inherit pypi
fi

DESCRIPTION="Deduplicating backup program with compression and authenticated encryption"
HOMEPAGE="https://borgbackup.readthedocs.io/"

LICENSE="BSD"
SLOT="0"

# Unfortunately we have a file conflict with app-office/borg, bug #580402
# borgbackup is *very* picky about which msgpack it work with,
# check setup.py on bumps.
RDEPEND="
	!!app-office/borg
	app-arch/lz4
	virtual/acl
	dev-python/pyfuse3[${PYTHON_USEDEP}]
	~dev-python/msgpack-1.0.4[${PYTHON_USEDEP}]
	dev-libs/openssl:0=
"

DEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.29[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	${RDEPEND}
"

src_install() {
	distutils-r1_src_install
	doman docs/man/*

	dobashcomp scripts/shell_completions/bash/borg

	insinto /usr/share/zsh/site-functions
	doins scripts/shell_completions/zsh/_borg

	insinto /usr/share/fish/vendor_completions.d
	doins scripts/shell_completions/fish/borg.fish
}
