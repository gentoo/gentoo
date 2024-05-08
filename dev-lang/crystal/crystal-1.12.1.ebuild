# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

BV="${PV}-1"
BV_AMD64="${BV}-linux-x86_64"

LLVM_MAX_SLOT=17

inherit bash-completion-r1 llvm multiprocessing toolchain-funcs

DESCRIPTION="The Crystal Programming Language"
HOMEPAGE="https://crystal-lang.org/
	https://github.com/crystal-lang/crystal/"
SRC_URI="
	https://github.com/crystal-lang/crystal/archive/${PV}.tar.gz
		-> ${P}.tar.gz
	amd64? (
		https://github.com/crystal-lang/crystal/releases/download/${BV/-*}/crystal-${BV_AMD64}.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc debug llvm-libunwind"

# Upstream test suite not reliable
RESTRICT="test"

DEPEND="
	<sys-devel/llvm-$((${LLVM_MAX_SLOT} + 1)):=
	dev-libs/boehm-gc:=[threads]
	dev-libs/gmp:=
	dev-libs/libatomic_ops:=
	dev-libs/libevent:=
	dev-libs/libpcre2:=[unicode]
	dev-libs/pcl:=
	llvm-libunwind? (
		sys-libs/llvm-libunwind:=
	)
	!llvm-libunwind? (
		sys-libs/libunwind:=
	)
"
RDEPEND="
	${DEPEND}
	dev-libs/libxml2
	dev-libs/libyaml
"

PATCHES=(
	"${FILESDIR}/${PN}-1.7.2-extra-spec-flags.patch"
	"${FILESDIR}/${PN}-0.27.0-gentoo-tests-long-unix.patch"
	"${FILESDIR}/${PN}-0.27.0-gentoo-tests-long-unix-2.patch"
)

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

		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LLVM_CONFIG="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
	)
}

src_compile() {
	emake "${MY_EMAKE_COMMON_ARGS[@]}"

	use doc && emake docs "${MY_EMAKE_COMMON_ARGS[@]}"
}

src_test() {
	# EXTRA_SPEC_FLAGS is useful to debug individual tests
	# as part of full build:
	#    USE=debug EXTRA_SPEC_FLAGS='-e parse_set_cookie' emerge -1 crystal
	emake std_spec \
		"${MY_EMAKE_COMMON_ARGS[@]}" "EXTRA_SPEC_FLAGS=${EXTRA_SPEC_FLAGS}"
}

src_install() {
	insinto "/usr/$(get_libdir)/crystal"
	doins -r src/.

	exeinto /usr/bin
	doexe .build/crystal

	insinto /usr/share/zsh/site-functions
	newins etc/completion.zsh _crystal

	dodoc -r samples
	doman "man/${PN}.1"
	newbashcomp etc/completion.bash "${PN}"

	if use doc ; then
		docinto api
		dodoc -r docs/.
	fi
}
