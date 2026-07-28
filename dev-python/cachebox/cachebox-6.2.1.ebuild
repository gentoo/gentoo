# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=maturin
PYPI_VERIFY_REPO=https://github.com/awolverp/cachebox
PYTHON_COMPAT=( python3_{12..15} )

RUST_MIN_VER="1.83.0"
CRATES="
	allocator-api2@0.4.0
	android_system_properties@0.1.5
	autocfg@1.5.1
	bitflags@2.13.0
	bumpalo@3.20.3
	cc@1.2.64
	cfg-if@1.0.4
	chrono@0.4.45
	core-foundation-sys@0.8.7
	fastrand@2.4.1
	find-msvc-tools@0.1.9
	futures-core@0.3.32
	futures-task@0.3.32
	futures-util@0.3.32
	heck@0.5.0
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.65
	js-sys@0.3.102
	libc@0.2.186
	lock_api@0.4.14
	log@0.4.32
	num-traits@0.2.19
	once_cell@1.21.4
	parking_lot@0.12.5
	parking_lot_core@0.9.12
	pin-project-lite@0.2.17
	portable-atomic@1.13.1
	proc-macro2@1.0.106
	pyo3-build-config@0.29.0
	pyo3-ffi@0.29.0
	pyo3-macros-backend@0.29.0
	pyo3-macros@0.29.0
	pyo3@0.29.0
	quote@1.0.45
	redox_syscall@0.5.18
	rustversion@1.0.22
	scopeguard@1.2.0
	shlex@2.0.1
	slab@0.4.12
	smallvec@1.15.2
	syn@2.0.117
	target-lexicon@0.13.5
	unicode-ident@1.0.24
	wasm-bindgen-macro-support@0.2.125
	wasm-bindgen-macro@0.2.125
	wasm-bindgen-shared@0.2.125
	wasm-bindgen@0.2.125
	windows-core@0.62.2
	windows-implement@0.60.2
	windows-interface@0.59.3
	windows-link@0.2.1
	windows-result@0.4.1
	windows-strings@0.5.1
"

inherit cargo distutils-r1 pypi

DESCRIPTION="The fastest memoizing and caching Python library written in Rust"
HOMEPAGE="
	https://github.com/awolverp/cachebox/
	https://pypi.org/project/cachebox/
"
SRC_URI+="
	${CARGO_CRATE_URIS}
"

LICENSE="MIT"
# Dependent crate licenses
LICENSE+=" Apache-2.0-with-LLVM-exceptions MIT Unicode-3.0"
SLOT="0"
KEYWORDS="~amd64"

EPYTEST_PLUGINS=( hypothesis pytest-asyncio )
distutils_enable_tests pytest

# Rust
QA_FLAGS_IGNORED="usr/lib/python.*/site-packages/cachebox/_core.*"

src_unpack() {
	pypi_src_unpack
	cargo_src_unpack
}

python_test() {
	rm -rf cachebox || die
	epytest
}
