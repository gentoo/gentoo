# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CARGO_OPTIONAL=1
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1
PYTHON_COMPAT=( python3_{10..14} )
PYTHON_REQ_USE="threads(+)"
RUST_MIN_VER="1.85.0"

CRATES="
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	allocator-api2@0.2.21
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anstream@0.6.18
	anstyle-parse@0.2.6
	anstyle-query@1.1.2
	anstyle-wincon@3.0.7
	anstyle@1.0.10
	autocfg@1.4.0
	bit-set@0.8.0
	bit-vec@0.8.0
	bitflags@2.9.0
	bitmaps@2.1.0
	bitvec@1.0.1
	block-buffer@0.10.4
	block-buffer@0.9.0
	bstr@1.12.0
	bumpalo@3.17.0
	byteorder@1.5.0
	bytes-cast-derive@0.2.0
	bytes-cast@0.3.0
	cc@1.2.21
	cfg-if@1.0.0
	cfg_aliases@0.2.1
	chrono@0.4.41
	clap@4.5.37
	clap_builder@4.5.37
	clap_derive@4.5.32
	clap_lex@0.7.4
	colorchoice@1.0.3
	console@0.16.0
	core-foundation-sys@0.8.7
	cpufeatures@0.2.17
	crc32fast@1.4.2
	crossbeam-channel@0.5.15
	crossbeam-deque@0.8.6
	crossbeam-epoch@0.9.18
	crossbeam-utils@0.8.21
	crypto-common@0.1.6
	ctrlc@3.4.6
	dashmap@6.1.0
	derive_more-impl@2.0.1
	derive_more@2.0.1
	diff@0.1.13
	digest@0.10.7
	digest@0.9.0
	dirs-sys@0.5.0
	dirs@6.0.0
	dyn-clone@1.0.19
	either@1.15.0
	encode_unicode@1.0.0
	env_home@0.1.0
	equivalent@1.0.2
	errno@0.3.11
	fastrand@2.3.0
	filetime@0.2.25
	flate2@1.1.1
	foldhash@0.1.5
	format-bytes-macros@0.4.0
	format-bytes@0.3.0
	funty@2.0.0
	generic-array@0.14.7
	getrandom@0.1.16
	getrandom@0.2.16
	getrandom@0.3.2
	hashbrown@0.13.2
	hashbrown@0.14.5
	hashbrown@0.15.4
	heck@0.5.0
	hex@0.4.3
	home@0.5.11
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.63
	im-rc@15.1.0
	imara-diff@0.2.0
	indexmap@2.10.0
	indicatif@0.18.0
	indoc@2.0.6
	is_terminal_polyfill@1.70.1
	itertools@0.14.0
	itoa@1.0.15
	jobserver@0.1.33
	js-sys@0.3.77
	lazy_static@1.5.0
	libc@0.2.172
	libm@0.2.14
	libredox@0.1.3
	libz-sys@1.1.22
	linux-raw-sys@0.9.4
	lock_api@0.4.12
	log@0.4.27
	matchers@0.1.0
	memchr@2.7.4
	memmap2@0.9.5
	memoffset@0.9.1
	miniz_oxide@0.8.8
	nix@0.29.0
	nu-ansi-term@0.46.0
	num-traits@0.2.19
	once_cell@1.21.3
	opaque-debug@0.3.1
	option-ext@0.2.0
	os_str_bytes@6.6.1
	overload@0.1.1
	parking_lot_core@0.9.10
	pin-project-lite@0.2.16
	pkg-config@0.3.32
	portable-atomic@1.11.0
	ppv-lite86@0.2.21
	pretty_assertions@1.4.1
	proc-macro2@1.0.95
	pyo3-build-config@0.27.1
	pyo3-ffi@0.27.1
	pyo3-macros-backend@0.27.1
	pyo3-macros@0.27.1
	pyo3@0.27.1
	quote@1.0.40
	r-efi@5.2.0
	radium@0.7.0
	rand@0.7.3
	rand@0.8.5
	rand@0.9.1
	rand_chacha@0.2.2
	rand_chacha@0.3.1
	rand_chacha@0.9.0
	rand_core@0.5.1
	rand_core@0.6.4
	rand_core@0.9.3
	rand_distr@0.5.1
	rand_hc@0.2.0
	rand_pcg@0.9.0
	rand_xoshiro@0.6.0
	rayon-core@1.12.1
	rayon@1.10.0
	redox_syscall@0.5.12
	redox_users@0.5.0
	regex-automata@0.1.10
	regex-automata@0.4.9
	regex-syntax@0.6.29
	regex-syntax@0.8.5
	regex@1.11.1
	rustix@1.0.7
	rustversion@1.0.20
	ryu@1.0.20
	same-file@1.0.6
	schnellru@0.2.4
	scopeguard@1.2.0
	self_cell@1.2.0
	serde@1.0.219
	serde_derive@1.0.219
	serde_json@1.0.140
	serde_spanned@1.0.0
	sha-1@0.10.1
	sha-1@0.9.8
	sha2@0.10.9
	sharded-slab@0.1.7
	shellexpand@3.1.1
	shlex@1.3.0
	sized-chunks@0.6.5
	smallvec@1.15.0
	stable_deref_trait@1.2.0
	static_assertions_next@1.1.2
	strsim@0.11.1
	syn@1.0.109
	syn@2.0.104
	tap@1.0.1
	target-lexicon@0.13.2
	tempfile@3.19.1
	thiserror-impl@2.0.12
	thiserror@2.0.12
	thread_local@1.1.8
	toml@0.9.5
	toml_datetime@0.7.0
	toml_parser@1.0.2
	toml_writer@1.0.2
	tracing-attributes@0.1.28
	tracing-chrome@0.7.2
	tracing-core@0.1.33
	tracing-log@0.2.0
	tracing-subscriber@0.3.19
	tracing@0.1.41
	twox-hash@2.1.0
	typenum@1.18.0
	unicode-ident@1.0.18
	unicode-width@0.2.0
	unicode-xid@0.2.6
	unindent@0.2.4
	unit-prefix@0.5.1
	utf8parse@0.2.2
	uuid@1.16.0
	valuable@0.1.1
	vcpkg@0.2.15
	vcsgraph@0.2.0
	version_check@0.9.5
	wasi@0.11.0+wasi-snapshot-preview1
	wasi@0.14.2+wasi-0.2.4
	wasi@0.9.0+wasi-snapshot-preview1
	wasite@0.1.0
	wasm-bindgen-backend@0.2.100
	wasm-bindgen-macro-support@0.2.100
	wasm-bindgen-macro@0.2.100
	wasm-bindgen-shared@0.2.100
	wasm-bindgen@0.2.100
	web-sys@0.3.77
	web-time@1.1.0
	which@8.0.0
	whoami@1.6.0
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.61.0
	windows-implement@0.60.0
	windows-interface@0.59.1
	windows-link@0.1.3
	windows-result@0.3.2
	windows-strings@0.4.0
	windows-sys@0.59.0
	windows-sys@0.60.2
	windows-targets@0.52.6
	windows-targets@0.53.3
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_gnullvm@0.53.0
	windows_aarch64_msvc@0.52.6
	windows_aarch64_msvc@0.53.0
	windows_i686_gnu@0.52.6
	windows_i686_gnu@0.53.0
	windows_i686_gnullvm@0.52.6
	windows_i686_gnullvm@0.53.0
	windows_i686_msvc@0.52.6
	windows_i686_msvc@0.53.0
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnu@0.53.0
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_gnullvm@0.53.0
	windows_x86_64_msvc@0.52.6
	windows_x86_64_msvc@0.53.0
	winnow@0.7.12
	winsafe@0.0.19
	wit-bindgen-rt@0.39.0
	wyz@0.5.1
	yansi@1.0.1
	zerocopy-derive@0.7.35
	zerocopy-derive@0.8.25
	zerocopy@0.7.35
	zerocopy@0.8.25
	zstd-safe@7.2.4
	zstd-sys@2.0.15+zstd.1.5.7
	zstd@0.13.3
"

inherit shell-completion cargo elisp-common distutils-r1 flag-o-matic multiprocessing

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"
SRC_URI="https://www.mercurial-scm.org/release/${P}.tar.gz
	rust? ( ${CARGO_CRATE_URIS} )"

LICENSE="GPL-2+
	rust? (
		Apache-2.0 Apache-2.0-with-LLVM-exceptions MIT MPL-2.0 Unicode-3.0 ZLIB
		 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="+chg emacs gpg tk rust"

BDEPEND="
	>=dev-python/setuptools-scm-8.1.0[${PYTHON_USEDEP}]
	rust? ( ${RUST_DEPEND} )"

RDEPEND="
	dev-python/zstandard[${PYTHON_USEDEP}]
	app-misc/ca-certificates
	gpg? ( app-alternatives/gpg )
	tk? ( dev-lang/tk )"

DEPEND="emacs? ( >=app-editors/emacs-23.1:* )"

SITEFILE="70${PN}-gentoo.el"

RESTRICT="test"  # test suite needs mercurial to be installed

pkg_setup() {
	use rust && rust_pkg_setup
}

src_unpack() {
	default_src_unpack
	if use rust; then
		local S="${S}/rust/hg-cpython"
		cargo_src_unpack
	else
		# Needed because distutils-r1 install under cargo_env if cargo is inherited
		cargo_gen_config
	fi
}

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die
	sed -i -e 's/__APPLE__/__NO_APPLE__/g' mercurial/cext/osutil.c || die

	# Build assumes the Rust target directory, which is wrong for us.
	sed -i -r "s:\brust[/,' ]+target[/,' ]+release\b:rust/$(cargo_target_dir):g" setup.py || die

	distutils-r1_python_prepare_all
}

python_configure_all() {
	# not use setup.cfg because hgdist.rust is not updated
	sed -i -r "s:rust = (False|True):rust = $(usex rust True False):" setup.py || die

	cat >> setup.cfg <<-EOF || die
		[build_ext]
		zstd = False
	EOF
}

src_compile() {
	if use rust; then
		pushd rust/hg-cpython || die
		cargo_src_compile --no-default-features --jobs $(makeopts_jobs)
		popd || die
	fi
	distutils-r1_src_compile
}

python_compile() {
	filter-flags -ftracer -ftree-vectorize
	distutils-r1_python_compile build_ext
}

python_compile_all() {
	rm -r contrib/win32 || die
	if use chg; then
		emake -C contrib/chg
	fi
	if use rust; then
		pushd rust/rhg || die
		cargo_src_compile --no-default-features --jobs $(makeopts_jobs)
		popd || die
	fi
	if use emacs; then
		cd contrib || die
		elisp-compile mercurial.el || die "elisp-compile failed!"
	fi
}

src_install() {
	distutils-r1_src_install
}

python_install() {
	distutils-r1_python_install build_ext
	python_doscript contrib/hg-ssh
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg
	newzshcomp contrib/zsh_completion _hg

	dobin hgeditor
	if use tk; then
		dobin contrib/hgk
	fi

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-make-site-file "${SITEFILE}"
	fi

	local RM_CONTRIB=( hgk hg-ssh bash_completion zsh_completion plan9 *.el )

	if use chg; then
		dobin contrib/chg/chg
		doman contrib/chg/chg.1
		RM_CONTRIB+=( chg )
	fi
	if use rust; then
		dobin "rust/$(cargo_target_dir)/rhg"
	fi

	for f in ${RM_CONTRIB[@]}; do
		rm -rf contrib/${f} || die
	done

	dodoc -r contrib
	docompress -x /usr/share/doc/${PF}/contrib
	doman doc/*.?
	dodoc CONTRIBUTORS hgweb.cgi

	insinto /etc/mercurial/hgrc.d
	doins "${FILESDIR}/cacerts.rc"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using"
	elog "the convert extension please install the correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
