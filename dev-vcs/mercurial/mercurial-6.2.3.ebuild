# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=no
CARGO_OPTIONAL=1

CRATES="
	Inflector-0.11.4
	adler-0.2.3
	ahash-0.4.7
	aho-corasick-0.7.18
	aliasable-0.1.3
	ansi_term-0.12.1
	atty-0.2.14
	autocfg-1.0.1
	bitflags-1.3.2
	bitmaps-2.1.0
	block-buffer-0.9.0
	block-buffer-0.10.2
	byteorder-1.4.3
	bytes-cast-0.2.0
	bytes-cast-derive-0.1.0
	cc-1.0.66
	cfg-if-0.1.10
	cfg-if-1.0.0
	chrono-0.4.19
	clap-2.34.0
	const_fn-0.4.4
	convert_case-0.4.0
	cpufeatures-0.1.4
	cpufeatures-0.2.1
	cpython-0.7.0
	crc32fast-1.2.1
	crossbeam-channel-0.5.2
	crossbeam-deque-0.8.0
	crossbeam-epoch-0.9.1
	crossbeam-utils-0.8.1
	crypto-common-0.1.2
	ctor-0.1.16
	derive_more-0.99.17
	diff-0.1.12
	digest-0.9.0
	digest-0.10.2
	either-1.6.1
	env_logger-0.9.0
	fastrand-1.7.0
	flate2-1.0.22
	format-bytes-0.3.0
	format-bytes-macros-0.4.0
	generic-array-0.14.4
	getrandom-0.1.15
	getrandom-0.2.4
	glob-0.3.0
	hashbrown-0.9.1
	hermit-abi-0.1.17
	hex-0.4.3
	home-0.5.3
	humantime-2.1.0
	im-rc-15.0.0
	instant-0.1.12
	itertools-0.9.0
	itertools-0.10.3
	jobserver-0.1.21
	lazy_static-1.4.0
	libc-0.2.124
	libm-0.2.1
	libz-sys-1.1.2
	log-0.4.14
	memchr-2.4.1
	memmap2-0.5.7
	memoffset-0.6.1
	micro-timer-0.4.0
	micro-timer-macros-0.4.0
	miniz_oxide-0.4.3
	num-integer-0.1.44
	num-traits-0.2.14
	num_cpus-1.13.0
	opaque-debug-0.3.0
	ouroboros-0.15.0
	ouroboros_macro-0.15.0
	output_vt100-0.1.2
	paste-1.0.5
	pkg-config-0.3.19
	ppv-lite86-0.2.10
	pretty_assertions-1.1.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.24
	python3-sys-0.7.0
	quote-1.0.7
	rand-0.7.3
	rand-0.8.5
	rand_chacha-0.2.2
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	rand_distr-0.4.3
	rand_hc-0.2.0
	rand_pcg-0.3.1
	rand_xoshiro-0.4.0
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.11
	regex-1.5.5
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	rustc_version-0.4.0
	same-file-1.0.6
	scopeguard-1.1.0
	semver-1.0.6
	sha-1-0.9.6
	sha-1-0.10.0
	sized-chunks-0.6.2
	stable_deref_trait-1.2.0
	static_assertions-1.1.0
	strsim-0.8.0
	syn-1.0.54
	tempfile-3.3.0
	termcolor-1.1.2
	textwrap-0.11.0
	time-0.1.44
	twox-hash-1.6.2
	typenum-1.12.0
	unicode-width-0.1.9
	unicode-xid-0.2.1
	users-0.11.0
	vcpkg-0.2.11
	vcsgraph-0.2.0
	vec_map-0.8.2
	version_check-0.9.2
	wasi-0.9.0+wasi-snapshot-preview1
	wasi-0.10.0+wasi-snapshot-preview1
	which-4.2.5
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
	zstd-0.5.4+zstd.1.4.7
	zstd-safe-2.0.6+zstd.1.4.7
	zstd-sys-1.4.18+zstd.1.4.7
"

inherit bash-completion-r1 cargo elisp-common distutils-r1 flag-o-matic multiprocessing

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"
SRC_URI="https://www.mercurial-scm.org/release/${P}.tar.gz
	rust? ( $(cargo_crate_uris ${CRATES}) )"

LICENSE="GPL-2+
	rust? ( BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 ISC MIT MPL-2.0 PSF-2 Unlicense ZLIB )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+chg emacs gpg test tk rust"

BDEPEND="rust? ( ${RUST_DEPEND} )"
RDEPEND="
	app-misc/ca-certificates
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )"

DEPEND="emacs? ( >=app-editors/emacs-23.1:* )
	test? (
		app-arch/unzip
		dev-python/pygments[${PYTHON_USEDEP}]
	)"

SITEFILE="70${PN}-gentoo.el"

RESTRICT="!test? ( test )"

src_unpack() {
	default_src_unpack
	if use rust; then
		local S="${S}/rust/hg-cpython"
		cargo_src_unpack
	fi
}

python_prepare_all() {
	# fix up logic that won't work in Gentoo Prefix (also won't outside in
	# certain cases), bug #362891
	sed -i -e 's:xcodebuild:nocodebuild:' setup.py || die
	sed -i -e 's/__APPLE__/__NO_APPLE__/g' mercurial/cext/osutil.c || die

	distutils-r1_python_prepare_all
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
	if use rust; then
		local -x HGWITHRUSTEXT="cpython"
	fi
	distutils-r1_python_compile build_ext
}

python_compile_all() {
	rm -r contrib/win32 || die
	if use chg; then
		emake -C contrib/chg
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
	if use rust; then
		local -x HGWITHRUSTEXT="cpython"
	fi

	distutils-r1_python_install build_ext
	python_doscript contrib/hg-ssh
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg

	insinto /usr/share/zsh/site-functions
	newins contrib/zsh_completion _hg

	dobin hgeditor
	if use tk; then
		dobin contrib/hgk
	fi

	if use emacs; then
		elisp-install ${PN} contrib/mercurial.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	local RM_CONTRIB=( hgk hg-ssh bash_completion zsh_completion plan9 *.el )

	if use chg; then
		dobin contrib/chg/chg
		doman contrib/chg/chg.1
		RM_CONTRIB+=( chg )
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

src_test() {
	pushd tests &>/dev/null || die
	rm -rf *svn*			# Subversion tests fail with 1.5
	rm -f test-archive*		# Fails due to verbose tar output changes
	rm -f test-convert-baz*		# GNU Arch baz
	rm -f test-convert-cvs*		# CVS
	rm -f test-convert-darcs*	# Darcs
	rm -f test-convert-git*		# git
	rm -f test-convert-mtn*		# monotone
	rm -f test-convert-tla*		# GNU Arch tla
	rm -f test-largefiles*		# tends to time out
	rm -f test-https*			# requires to support tls1.0
	rm -rf test-removeemptydirs*	# requires access to access parent directories
	if [[ ${EUID} -eq 0 ]]; then
		einfo "Removing tests which require user privileges to succeed"
		rm -f test-convert*
		rm -f test-lock-badness*
		rm -f test-permissions*
		rm -f test-pull-permission*
		rm -f test-journal-exists*
		rm -f test-repair-strip*
	fi

	popd &>/dev/null || die
	distutils-r1_src_test
}

python_test() {
	if [[ ${EPYTHON} == python3.10 ]]; then
		einfo "Skipping tests for unsupported Python 3.10"
		return
	fi
	distutils_install_for_testing
	cd tests || die
	PYTHONWARNINGS=ignore "${PYTHON}" run-tests.py \
		--jobs $(makeopts_jobs) \
		--timeout 0 \
		|| die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	use emacs && elisp-site-regen

	elog "If you want to convert repositories from other tools using convert"
	elog "extension please install correct tool:"
	elog "  dev-vcs/cvs"
	elog "  dev-vcs/darcs"
	elog "  dev-vcs/git"
	elog "  dev-vcs/monotone"
	elog "  dev-vcs/subversion"
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
