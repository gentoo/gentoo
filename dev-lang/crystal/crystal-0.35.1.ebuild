# Copyright 1999-2020 Gentoo Authors
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
IUSE="doc debug examples blocking-stdio-hack +xml +yaml"

RESTRICT=test # not stable for day-to-day runs

LLVM_MAX_SLOT=10

DEPEND="
	sys-devel/llvm:${LLVM_MAX_SLOT}
	dev-libs/boehm-gc[static-libs,threads]
	dev-libs/libatomic_ops
	dev-libs/libevent
	dev-libs/libpcre
	sys-libs/libunwind
	dev-libs/pcl
	dev-libs/gmp:0
"
RDEPEND="${DEPEND}
	xml? ( dev-libs/libxml2 )
	yaml? ( dev-libs/libyaml )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.31.0-verbose.patch
	"${FILESDIR}"/${PN}-0.26.1-gentoo-tests-sandbox.patch
	"${FILESDIR}"/${PN}-0.27.0-extra-spec-flags.patch
	#"${FILESDIR}"/${PN}-0.27.0-max-age-0-test.patch
	"${FILESDIR}"/${PN}-0.27.0-gentoo-tests-long-unix.patch
	"${FILESDIR}"/${PN}-0.27.0-gentoo-tests-long-unix-2.patch
)

src_prepare() {
	default

	use blocking-stdio-hack && eapply "${FILESDIR}"/"${PN}"-0.22.0-blocking-stdio-hack.patch
}

src_compile() {
	local bootstrap_path=${WORKDIR}/${PN}-${BV}/bin
	if [[ ! -d ${bootstrap_path} ]]; then
		eerror "Binary tarball does not contain expected directory:"
		die "'${bootstrap_path}' path does not exist."
	fi

	# crystal uses 'LLVM_TARGETS' to override default list of targets
	unset LLVM_TARGETS
	emake \
		$(usex debug "" release=1) \
		progress=true \
		stats=1 \
		threads=$(makeopts_jobs) \
		verbose=1 \
		\
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		\
		PATH="${bootstrap_path}:${PATH}" \
		CRYSTAL_PATH=src \
		CRYSTAL_CONFIG_VERSION=${PV} \
		CRYSTAL_CONFIG_PATH="lib:${EPREFIX}/usr/$(get_libdir)/crystal"
	use doc && emake docs
}

src_test() {
	# EXTRA_SPEC_FLAGS is useful to debug individual tests
	# as part of full build:
	#    USE=debug EXTRA_SPEC_FLAGS='-e parse_set_cookie' emerge -1 crystal
	emake spec \
		$(usex debug "" release=1) \
		progress=true \
		stats=1 \
		threads=$(makeopts_jobs) \
		verbose=1 \
		\
		CC=$(tc-getCC) \
		CXX=$(tc-getCXX) \
		AR=$(tc-getAR) \
		\
		CRYSTAL_PATH=src \
		CRYSTAL_CONFIG_VERSION=${PV} \
		\
		"EXTRA_SPEC_FLAGS=${EXTRA_SPEC_FLAGS}"
}

src_install() {
	insinto /usr/$(get_libdir)/crystal
	doins -r src/.
	dobin .build/crystal

	insinto /usr/share/zsh/site-functions
	newins etc/completion.zsh _crystal

	use examples && dodoc -r samples

	if use doc ; then
		docinto api
		dodoc -r docs/.
	fi

	newbashcomp etc/completion.bash ${PN}
}
