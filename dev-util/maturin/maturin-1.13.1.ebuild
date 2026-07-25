# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_UPSTREAM_PEP517=standalone
PYTHON_COMPAT=( pypy3_11 python3_{11..15} )
RUST_MIN_VER=1.88.0
inherit cargo distutils-r1 flag-o-matic shell-completion toolchain-funcs

DESCRIPTION="Build and publish crates with pyo3, rust-cpython and cffi bindings"
HOMEPAGE="https://www.maturin.rs/"
SRC_URI="
	https://github.com/PyO3/maturin/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://distfiles.gentoo.org/pub/dev/ionen@gentoo.org/${P}-vendor.tar.xz
"
# ^ tarball also includes test-crates' Cargo.lock(s) crates for tests

LICENSE="|| ( Apache-2.0 MIT ) doc? ( Apache-2.0 OFL-1.1 )"
LICENSE+="
	0BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD
	CDLA-Permissive-2.0 MIT MIT-0 MPL-2.0 Unicode-3.0 ZLIB BZIP2
" # crates
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc +ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-arch/xz-utils
	app-arch/zstd:=
	ssl? ( <dev-libs/openssl-4:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( >=app-text/mdbook-0.5 )
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

		# needed by several sdist:: tests
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

	use !doc || mdbook build -d "${T}"/html guide || die

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

	local CARGO_SKIP_TESTS=(
		# picky cli output test that easily benignly fail (bug #937992)
		cli_tests
		# fragile depending on rust version, also wants libpypy*-c.so for pypy
		errors::pyo3_no_extension_module
		# fails for unsupported rust targets, non-issue here (bug #973104)
		errors::pypi_compatibility_linux_tag
		# unimportant tests that require uv, and not obvious to get it
		# to work with network-sandbox (not worth the trouble)
		develop::develop_uv_cases::case_1_hello_world
		develop::develop_uv_cases::case_2_pyo3_ffi_pure
		# compliance tests using zig (if present) need old libc (bug #946967)
		integration::integration_cases::case_07_cffi_mixed_py_subdir
		integration::integration_cases::case_16_pyo3_stub_generation_zig
		# avoid need for wasm over a single hello world test
		integration::integration_wasm_hello_world
		# these currently attempt to install tomli regardless of python version
		pep517::pep517_default_profile
		pep517::pep517_editable_profile
		# unimportant and simpler to skip, does not work with just `git init`
		sdist::lib_with_parent_workspace_git_dep_sdist
	)

	cargo_src_test
}

python_install_all() {
	dobin "$(cargo_target_dir)"/maturin

	dodoc Changelog.md README.md
	use doc && dodoc -r "${T}"/html

	if ! tc-is-cross-compiler; then
		dobashcomp "${T}"/${PN}
		dofishcomp "${T}"/${PN}.fish
		dozshcomp "${T}"/_${PN}
	fi
}
