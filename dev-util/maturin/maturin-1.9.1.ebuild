# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_UPSTREAM_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
RUST_MIN_VER=1.75.0
inherit cargo distutils-r1 flag-o-matic shell-completion toolchain-funcs

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://www.maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${P}-vendor.tar.xz
"
# ^ tarball also includes test-crates' Cargo.lock(s) crates for tests

LICENSE="|| ( Apache-2.0 MIT ) doc? ( CC-BY-4.0 OFL-1.1 )"
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD Boost-1.0 MIT
	MPL-2.0 Unicode-3.0 Unicode-DFS-2016
" # crates
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/xz-utils
	app-arch/zstd:=
	ssl? ( dev-libs/openssl:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/mdbook )
	test? (
		$(python_gen_cond_dep 'dev-python/cffi[${PYTHON_USEDEP}]' 'python*')
		dev-python/boltons[${PYTHON_USEDEP}]
		dev-python/virtualenv[${PYTHON_USEDEP}]
		dev-vcs/git
		elibc_musl? ( dev-util/patchelf )
	)
"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_prepare() {
	distutils-r1_src_prepare

	# we build the Rust executable (just once) via cargo_src_compile
	sed -i -e '/setuptools_rust/d' -e '/rust_extensions/d' setup.py || die

	if use test; then
		# used to prevent use of network during tests, and silence pip
		# if it finds unrelated issues with system packages (bug #913613)
		cat > "${T}"/pip.conf <<-EOF || die
			[global]
			quiet = 2

			[install]
			no-index = yes
			no-dependencies = yes
		EOF

		# uv does not work easily w/ network-sandbox, force virtualenv
		sed -i 's/"uv"/"uv-not-found"/' tests/common/mod.rs || die

		# increase timeouts for tests (bug #950332)
		sed -i '/^#\[timeout/s/secs(60)/secs(300)/' tests/run.rs || die

		# used by *git_sdist_generator tests
		git init -q || die
		git config --global user.email "larry@gentoo.org" || die
		git config --global user.name "Larry the Cow" || die
		git add . || die
		git commit -qm init || die
	fi
}

src_configure() {
	export OPENSSL_NO_VENDOR=1
	export ZSTD_SYS_USE_PKG_CONFIG=1

	# https://github.com/rust-lang/stacker/issues/79
	use s390 && ! is-flagq '-march=*' &&
		append-cflags $(test-flags-CC -march=z10)

	local myfeatures=(
		# like release.yml + native-tls for better platform support than rustls
		full
		password-storage
		$(usev ssl native-tls)
	)

	cargo_src_configure --no-default-features
}

python_compile_all() {
	cargo_src_compile

	use !doc || mdbook build -d html guide || die

	if ! tc-is-cross-compiler; then
		local maturin=$(cargo_target_dir)/maturin
		"${maturin}" completions bash > "${T}"/${PN} || die
		"${maturin}" completions fish > "${T}"/${PN}.fish || die
		"${maturin}" completions zsh > "${T}"/_${PN} || die
	else
		ewarn "shell completion files were skipped due to cross-compilation"
	fi
}

python_test() {
	local -x MATURIN_TEST_PYTHON=${EPYTHON}
	local -x PIP_CONFIG_FILE=${T}/pip.conf
	local -x VIRTUALENV_SYSTEM_SITE_PACKAGES=1

	# need this for (new) python versions not yet recognized by pyo3
	local -x PYO3_USE_ABI3_FORWARD_COMPATIBILITY=1

	local skip=(
		# picky cli output test that easily benignly fail (bug #937992)
		--skip cli_tests
		# avoid need for wasm over a single hello world test
		--skip integration_wasm_hello_world
		# fragile depending on rust version, also wants libpypy*-c.so for pypy
		--skip pyo3_no_extension_module
		# unimportant tests that require uv, and not obvious to get it
		# to work with network-sandbox (not worth the trouble)
		--skip develop_hello_world::case_2
		--skip develop_pyo3_ffi_pure::case_2
		# compliance test using zig requires an old libc to pass (bug #946967)
		--skip integration_pyo3_mixed_py_subdir
		# fails on sparc since rust-1.74 (bug #934573), skip for now given
		# should not affect the pep517 backend which is all we need on sparc
		$(usev sparc '--skip build_context::test::test_macosx_deployment_target')
	)

	cargo_src_test -- "${skip[@]}"
}

python_install_all() {
	cargo_src_install

	dodoc Changelog.md README.md
	use doc && dodoc -r guide/html

	if ! tc-is-cross-compiler; then
		dobashcomp "${T}"/${PN}
		dofishcomp "${T}"/${PN}.fish
		dozshcomp "${T}"/_${PN}
	fi
}
