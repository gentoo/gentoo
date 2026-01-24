# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BV="${PV}-1"
BV_AMD64="${BV}-linux-x86_64"

LLVM_COMPAT=( {19..21} )

inherit llvm-r1 multiprocessing shell-completion toolchain-funcs

DESCRIPTION="The Crystal Programming Language"
HOMEPAGE="https://crystal-lang.org/
	https://github.com/crystal-lang/crystal/"
SRC_URI="
	https://github.com/crystal-lang/crystal/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	amd64? (
		https://github.com/crystal-lang/crystal/releases/download/${BV/-*}/crystal-${BV_AMD64}.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc debug llvm-libunwind"
RESTRICT="test"  # Upstream test suite not reliable.

DEPEND="
	dev-libs/boehm-gc:=[threads]
	dev-libs/gmp:=
	dev-libs/libatomic_ops:=
	dev-libs/libevent:=
	dev-libs/libpcre2:=[unicode]
	dev-libs/libxml2:=
	dev-libs/libyaml
	dev-libs/pcl:=
	$(llvm_gen_dep '
		llvm-core/llvm:${LLVM_SLOT}=
	')
	llvm-libunwind? (
		llvm-runtimes/libunwind:=
	)
	!llvm-libunwind? (
		sys-libs/libunwind:=
	)
"
RDEPEND="
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-0.27.0-gentoo-tests-long-unix.patch"
	"${FILESDIR}/${PN}-0.27.0-gentoo-tests-long-unix-2.patch"
	"${FILESDIR}/${PN}-1.15.0-remove-enviroment-clearing-tests.patch"
)

# Do not complain about CFLAGS etc. Crystal rebuilds itself.
QA_FLAGS_IGNORED='.*'

src_prepare() {
	default

	# Link against system boehm-gc instead of upstream prebuilt static library
	# bug #929123, #929989 and #931100
	# https://github.com/crystal-lang/crystal/issues/12035#issuecomment-2522606612
	rm "${WORKDIR}/crystal-${BV}"/lib/crystal/libgc.a || die
}

src_configure() {
	local bootstrap_path="${WORKDIR}/${PN}-${BV}/bin"

	if [[ ! -d "${bootstrap_path}" ]] ; then
		eerror "Binary tarball does not contain expected directory:"
		die "'${bootstrap_path}' path does not exist."
	fi

	# crystal uses 'LLVM_TARGETS' to override default list of targets
	unset LLVM_TARGETS

	MY_EMAKE_COMMON_ARGS=(
		PATH="${bootstrap_path}:${PATH}"

		CRYSTAL_CONFIG_VERSION="${PV}"
		CRYSTAL_CONFIG_PATH="lib:${EPREFIX}/usr/$(get_libdir)/crystal"

		$(usex debug "" release=1)
		progress=true
		stats=1
		threads="$(makeopts_jobs)"
		verbose=1
		check_lld= # disable opportunistic lld

		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LLVM_CONFIG="$(get_llvm_prefix -d)/bin/llvm-config"
	)
}

src_compile() {
	emake "${MY_EMAKE_COMMON_ARGS[@]}"

	if use doc ; then
		emake docs "${MY_EMAKE_COMMON_ARGS[@]}"
	fi
}

src_test() {
	nonfatal emake std_spec "${MY_EMAKE_COMMON_ARGS[@]}"
}

src_install() {
	insinto "/usr/$(get_libdir)/crystal"
	doins -r src/.

	exeinto /usr/bin
	doexe .build/crystal

	newzshcomp etc/completion.zsh _crystal
	newfishcomp etc/completion.fish crystal.fish

	dodoc -r samples
	doman "man/${PN}.1"
	newbashcomp etc/completion.bash "${PN}"

	if use doc ; then
		docinto api
		dodoc -r docs/.
	fi
}
