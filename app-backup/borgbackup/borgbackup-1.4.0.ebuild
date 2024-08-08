# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit bash-completion-r1 distutils-r1 pypi

DESCRIPTION="Deduplicating backup program with compression and authenticated encryption"
HOMEPAGE="https://borgbackup.readthedocs.io/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	app-arch/lz4
	app-arch/zstd
	dev-libs/openssl:0=
	>=dev-libs/xxhash-0.8.1
	virtual/acl
"
# borgbackup is *very* picky about which msgpack it work with,
# check setup.py on bumps.
RDEPEND="
	${DEPEND}
	<=dev-python/msgpack-1.1.0[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/pyfuse3[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/pkgconfig[${PYTHON_USEDEP}]
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/python-dateutil[${PYTHON_USEDEP}]
	)
"

# some tests randomly fail with xdist, bug #936524
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# Needs pytest-benchmark fixture
		benchmark.py::test_
	)

	# This disables fuse releated tests
	local -x BORG_FUSE_IMPL="none"
	epytest --pyargs borg.testsuite
}

src_install() {
	distutils-r1_src_install
	doman docs/man/*

	dobashcomp scripts/shell_completions/bash/borg

	insinto /usr/share/zsh/site-functions
	doins scripts/shell_completions/zsh/_borg

	insinto /usr/share/fish/vendor_completions.d
	doins scripts/shell_completions/fish/borg.fish
}
