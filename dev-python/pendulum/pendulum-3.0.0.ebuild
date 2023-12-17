# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYTHON_COMPAT=( pypy3 python3_{10..12} )

CRATES="
	autocfg@1.1.0
	bitflags@1.3.2
	cc@1.0.79
	cfg-if@1.0.0
	indoc@1.0.9
	libc@0.2.139
	libmimalloc-sys@0.1.35
	lock_api@0.4.9
	memoffset@0.9.0
	mimalloc@0.1.39
	once_cell@1.17.1
	parking_lot@0.12.1
	parking_lot_core@0.9.7
	proc-macro2@1.0.51
	pyo3-build-config@0.19.1
	pyo3-ffi@0.19.1
	pyo3-macros-backend@0.19.1
	pyo3-macros@0.19.1
	pyo3@0.19.1
	python3-dll-a@0.2.9
	quote@1.0.23
	redox_syscall@0.2.16
	scopeguard@1.1.0
	smallvec@1.10.0
	syn@1.0.109
	target-lexicon@0.12.6
	unicode-ident@1.0.6
	unindent@0.1.11
	windows-sys@0.45.0
	windows-targets@0.42.1
	windows_aarch64_gnullvm@0.42.1
	windows_aarch64_msvc@0.42.1
	windows_i686_gnu@0.42.1
	windows_i686_msvc@0.42.1
	windows_x86_64_gnu@0.42.1
	windows_x86_64_gnullvm@0.42.1
	windows_x86_64_msvc@0.42.1
"

inherit cargo distutils-r1

DESCRIPTION="Drop-in replacement for the standard datetime class"
HOMEPAGE="
	https://pendulum.eustace.io/
	https://github.com/sdispater/pendulum/
	https://pypi.org/project/pendulum/
"
SRC_URI="
	https://github.com/sdispater/pendulum/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+="
	Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT Unicode-DFS-2016
"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	>=dev-python/python-dateutil-2.6[${PYTHON_USEDEP}]
	>=dev-python/tzdata-2020.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		>=dev-python/time-machine-2.6.0[${PYTHON_USEDEP}]
	' 'python*')
"
BDEPEND="
	test? (
		dev-python/Babel[${PYTHON_USEDEP}]
		>=dev-python/pytz-2022.1[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
