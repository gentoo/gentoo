# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit bash-completion-r1 llvm multiprocessing toolchain-funcs

BV=${PV}-1
BV_AMD64=${BV}-linux-x86_64
BV_X86=${BV}-linux-i686

DESCRIPTION="The Crystal Programming Language"
HOMEPAGE="https://crystal-lang.org"
SRC_URI="https://github.com/crystal-lang/crystal/archive/${PV}.tar.gz -> ${P}.tar.gz
	amd64? ( https://github.com/crystal-lang/crystal/releases/download/${BV/-*}/crystal-${BV_AMD64}.tar.gz )
	x86? ( https://github.com/crystal-lang/crystal/releases/download/${BV/-*}/crystal-${BV_X86}.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc debug"

# Upstream test suite not reliable
RESTRICT=test

# See https://github.com/crystal-lang/crystal/issues/10434
LLVM_MAX_SLOT=11

DEPEND="
	dev-libs/boehm-gc[static-libs,threads]
	dev-libs/gmp:=
	dev-libs/libatomic_ops
	dev-libs/libevent
	dev-libs/libpcre
	dev-libs/pcl:=
	sys-devel/llvm:${LLVM_MAX_SLOT}
	sys-libs/libunwind:=
"
RDEPEND="${DEPEND}
	dev-libs/libxml2
	dev-libs/libyaml
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-verbose.patch
	"${FILESDIR}"/${PN}-0.26.1-gentoo-tests-sandbox.patch
	"${FILESDIR}"/${PN}-0.27.0-extra-spec-flags.patch
	"${FILESDIR}"/${PN}-0.27.0-gentoo-tests-long-unix.patch
	"${FILESDIR}"/${PN}-0.27.0-gentoo-tests-long-unix-2.patch
)

src_configure() {
	local bootstrap_path=${WORKDIR}/${PN}-${BV}/bin
	if [[ ! -d ${bootstrap_path} ]]; then
		eerror "Binary tarball does not contain expected directory:"
		die "'${bootstrap_path}' path does not exist."
	fi

	MY_EMAKE_COMMON_ARGS=(
		$(usex debug "" release=1)
		progress=true
		stats=1
		threads=$(makeopts_jobs)
		verbose=1
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		AR="$(tc-getAR)"
		LLVM_CONFIG="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/bin/llvm-config"
		PATH="${bootstrap_path}:${PATH}"
		CRYSTAL_PATH=src
		CRYSTAL_CONFIG_VERSION=${PV}
		CRYSTAL_CONFIG_PATH="lib:${EPREFIX}/usr/$(get_libdir)/crystal"
	)

	# crystal uses 'LLVM_TARGETS' to override default list of targets
	unset LLVM_TARGETS
}

src_compile() {
	emake "${MY_EMAKE_COMMON_ARGS[@]}"
	use doc && emake docs
}

src_test() {
	# EXTRA_SPEC_FLAGS is useful to debug individual tests
	# as part of full build:
	#    USE=debug EXTRA_SPEC_FLAGS='-e parse_set_cookie' emerge -1 crystal
	emake std_spec "${MY_EMAKE_COMMON_ARGS[@]}" "EXTRA_SPEC_FLAGS=${EXTRA_SPEC_FLAGS}"
}

src_install() {
	insinto /usr/$(get_libdir)/crystal
	doins -r src/.
	dobin .build/crystal

	insinto /usr/share/zsh/site-functions
	newins etc/completion.zsh _crystal

	dodoc -r samples

	if use doc ; then
		docinto api
		dodoc -r docs/.
	fi

	newbashcomp etc/completion.bash ${PN}
}
