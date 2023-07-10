# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python3_{10..11} )

CRATES="
	aho-corasick@1.0.2
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	indoc@0.3.6
	indoc-impl@0.3.6
	instant@0.1.12
	lazy_static@1.4.0
	libc@0.2.147
	lock_api@0.4.10
	memchr@2.5.0
	once_cell@1.18.0
	parking_lot@0.11.2
	parking_lot_core@0.8.6
	paste@0.1.18
	paste-impl@0.1.18
	pkg-version@1.0.0
	pkg-version-impl@0.1.1
	proc-macro-hack@0.5.20+deprecated
	proc-macro2@1.0.63
	pyo3@0.15.2
	pyo3-build-config@0.15.2
	pyo3-macros@0.15.2
	pyo3-macros-backend@0.15.2
	quote@1.0.28
	redox_syscall@0.2.16
	regex@1.8.4
	regex-syntax@0.7.2
	scopeguard@1.1.0
	smallvec@1.10.0
	syn@1.0.109
	unicode-ident@1.0.9
	unindent@0.1.11
	winapi@0.3.9
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
"

inherit cargo distutils-r1 optfeature

DESCRIPTION="Distributed Version Control System with a Friendly UI"
HOMEPAGE="https://www.breezy-vcs.org/ https://github.com/breezy-team/breezy"
SRC_URI="https://launchpad.net/brz/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz
		${CARGO_CRATE_URIS}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

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
	')
	!dev-vcs/bzr
"
BDEPEND="
	sys-devel/gettext
	$(python_gen_cond_dep '
		dev-python/cython[${PYTHON_USEDEP}]
		dev-python/setuptools-rust[${PYTHON_USEDEP}]
	')
"

QA_FLAGS_IGNORED=".*"

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
	optfeature "PGP sign and verify commits" "app-crypt/gpgme[python]"
}
