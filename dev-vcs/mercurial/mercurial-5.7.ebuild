# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="threads(+)"
DISTUTILS_USE_SETUPTOOLS=no
CARGO_OPTIONAL=1

CRATES="
adler-0.2.3
aho-corasick-0.7.15
ansi_term-0.11.0
atty-0.2.14
autocfg-1.0.1
bitflags-1.2.1
bitmaps-2.1.0
byteorder-1.3.4
cc-1.0.66
cfg-if-0.1.10
cfg-if-1.0.0
clap-2.33.3
const_fn-0.4.4
cpython-0.4.1
crc32fast-1.2.1
crossbeam-channel-0.4.4
crossbeam-channel-0.5.0
crossbeam-deque-0.8.0
crossbeam-epoch-0.9.1
crossbeam-utils-0.7.2
crossbeam-utils-0.8.1
ctor-0.1.16
difference-2.0.0
either-1.6.1
env_logger-0.7.1
flate2-1.0.19
format-bytes-0.1.3
format-bytes-macros-0.1.2
fuchsia-cprng-0.1.1
gcc-0.3.55
getrandom-0.1.15
glob-0.3.0
hermit-abi-0.1.17
hex-0.4.2
humantime-1.3.0
im-rc-15.0.0
itertools-0.9.0
jobserver-0.1.21
lazy_static-1.4.0
libc-0.2.81
libz-sys-1.1.2
log-0.4.11
maybe-uninit-2.0.0
memchr-2.3.4
memmap-0.7.0
memoffset-0.6.1
micro-timer-0.3.1
micro-timer-macros-0.3.1
miniz_oxide-0.4.3
num-traits-0.2.14
num_cpus-1.13.0
output_vt100-0.1.2
pkg-config-0.3.19
ppv-lite86-0.2.10
pretty_assertions-0.6.1
proc-macro-hack-0.5.19
proc-macro2-1.0.24
python27-sys-0.4.1
python3-sys-0.4.1
quick-error-1.2.3
quote-1.0.7
rand-0.3.23
rand-0.4.6
rand-0.7.3
rand_chacha-0.2.2
rand_core-0.3.1
rand_core-0.4.2
rand_core-0.5.1
rand_distr-0.2.2
rand_hc-0.2.0
rand_pcg-0.2.1
rand_xoshiro-0.4.0
rayon-1.5.0
rayon-core-1.9.0
rdrand-0.4.0
redox_syscall-0.1.57
regex-1.4.2
regex-syntax-0.6.21
remove_dir_all-0.5.3
rust-crypto-0.2.36
rustc-serialize-0.3.24
same-file-1.0.6
scopeguard-1.1.0
sized-chunks-0.6.2
static_assertions-1.1.0
strsim-0.8.0
syn-1.0.54
tempfile-3.1.0
termcolor-1.1.2
textwrap-0.11.0
thread_local-1.0.1
time-0.1.44
twox-hash-1.6.0
typenum-1.12.0
unicode-width-0.1.8
unicode-xid-0.2.1
vcpkg-0.2.11
vec_map-0.8.2
version_check-0.9.2
wasi-0.10.0+wasi-snapshot-preview1
wasi-0.9.0+wasi-snapshot-preview1
winapi-0.3.9
winapi-i686-pc-windows-gnu-0.4.0
winapi-util-0.1.5
winapi-x86_64-pc-windows-gnu-0.4.0
zstd-0.5.3+zstd.1.4.5
zstd-safe-2.0.5+zstd.1.4.5
zstd-sys-1.4.17+zstd.1.4.5
"

inherit bash-completion-r1 cargo elisp-common eutils distutils-r1 flag-o-matic

DESCRIPTION="Scalable distributed SCM"
HOMEPAGE="https://www.mercurial-scm.org/"
SRC_URI="https://www.mercurial-scm.org/release/${P}.tar.gz
	rust? ( $(cargo_crate_uris ${CRATES}) )"

LICENSE="GPL-2+
	rust? ( BSD Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD-2 ISC MIT PSF-2 Unlicense )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+chg emacs gpg test tk rust zsh-completion"

BDEPEND="rust? ( ${RUST_DEPEND} )"
RDEPEND="
	app-misc/ca-certificates
	dev-python/zstandard[${PYTHON_USEDEP}]
	gpg? ( app-crypt/gnupg )
	tk? ( dev-lang/tk )
	zsh-completion? ( app-shells/zsh )"

DEPEND="emacs? ( >=app-editors/emacs-23.1:* )
	test? (
		app-arch/unzip
		dev-python/pygments[${PYTHON_USEDEP}]
		)"

SITEFILE="70${PN}-gentoo.el"

# Too many tests fail #608720
RESTRICT="test"

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
	# Use absolute import for zstd
	sed -i -e 's/from \.* import zstd/import zstandard as zstd/' \
		mercurial/utils/compression.py \
		mercurial/wireprotoframing.py || die

	distutils-r1_python_prepare_all
}

src_compile() {
	if use rust; then
		pushd rust/hg-cpython || die
		cargo_src_compile --no-default-features --features python3
		popd
	fi
	distutils-r1_src_compile
}

python_compile() {
	filter-flags -ftracer -ftree-vectorize
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"
	if use rust; then
		local -x HGWITHRUSTEXT="cpython"
	fi
	distutils-r1_python_compile build_ext --no-zstd
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
	distutils-r1_python_install build_ext --no-zstd
}

python_install_all() {
	distutils-r1_python_install_all

	newbashcomp contrib/bash_completion hg

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh_completion _hg
	fi

	dobin hgeditor
	if use tk; then
		dobin contrib/hgk
	fi
	python_foreach_impl python_doscript contrib/hg-ssh

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
	local TEST_DIR

	rm -rf "${TMPDIR}"/test
	distutils_install_for_testing
	cd tests || die
	"${PYTHON}" run-tests.py --verbose \
		--tmpdir="${TMPDIR}"/test \
		--with-hg="${TEST_DIR}"/scripts/hg \
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
