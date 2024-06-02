# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit python-any-r1 toolchain-funcs

DESCRIPTION="BLAS-like Library Instantiation Software Framework"
HOMEPAGE="https://github.com/flame/blis"
SRC_URI="https://github.com/flame/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
CPU_USE=(
	cpu_flags_ppc_{vsx,vsx3}
	cpu_flags_arm_{neon,v7,v8,sve}
	cpu_flags_x86_{ssse3,avx,fma3,fma4,avx2,avx512vl}
)
IUSE="doc eselect-ldso openmp pthread serial static-libs 64bit-index ${CPU_USE[@]}"
REQUIRED_USE="
	?? ( openmp pthread serial )
	?? ( eselect-ldso 64bit-index )"

DEPEND="
	eselect-ldso? (
		!app-eselect/eselect-cblas
		>=app-eselect/eselect-blas-0.2
	)"

RDEPEND="${DEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-blas-provider.patch
	# to prevent QA Notice: pkg-config files with wrong LDFLAGS detected
	"${FILESDIR}"/${PN}-0.8.1-pkg-config.patch
	"${FILESDIR}"/${PN}-0.9.0-rpath.patch
)

get_confname() {
	local confname=generic
	if use x86 || use amd64; then
		use cpu_flags_x86_ssse3 && confname=penryn
		use cpu_flags_x86_avx && use cpu_flags_x86_fma3 && confname=sandybridge
		use cpu_flags_x86_avx && use cpu_flags_x86_fma4 && confname=bulldozer
		use cpu_flags_x86_avx && use cpu_flags_x86_fma4 && use cpu_flags_x86_fma3 && confname=piledriver
		use cpu_flags_x86_avx2 && confname=haswell
		use cpu_flags_x86_avx512vl && confname=skx
	elif use arm || use arm64; then
		use arm && confname=arm32
		use arm64 && confname=arm64
		use cpu_flags_arm_neon && use cpu_flags_arm_v7 && confname=cortexa9
		use cpu_flags_arm_v8 && confname=cortexa53
		use cpu_flags_arm_sve && confname=armsve
	elif use ppc || use ppc64; then
		confname=power
		use cpu_flags_ppc_vsx && confname=power7
		use cpu_flags_ppc_vsx3 && confname=power9
	fi
	echo ${confname}
}

src_configure() {
	local BLIS_FLAGS=()
	# determine flags
	if use openmp; then
		BLIS_FLAGS+=( -t openmp )
	elif use pthread; then
		BLIS_FLAGS+=( -t pthreads )
	else
		BLIS_FLAGS+=( -t no )
	fi
	use 64bit-index && BLIS_FLAGS+=( -b 64 -i 64 )

	# This is not an autotools configure file. We don't use econf here.
	CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" ./configure \
		--enable-verbose-make \
		--prefix="${BROOT}"/usr \
		--libdir="${BROOT}"/usr/$(get_libdir) \
		$(use_enable static-libs static) \
		--enable-blas \
		--enable-cblas \
		"${BLIS_FLAGS[@]}" \
		--enable-shared \
		$(get_confname) || die
}

src_compile() {
	DEB_LIBBLAS=libblas.so.3 DEB_LIBCBLAS=libcblas.so.3 \
		LDS_BLAS="${FILESDIR}"/blas.lds LDS_CBLAS="${FILESDIR}"/cblas.lds \
		default
}

src_test() {
	LD_LIBRARY_PATH=lib/$(get_confname) emake testblis-fast
	./testsuite/check-blistest.sh ./output.testsuite || die
}

src_install() {
	default
	use doc && dodoc README.md docs/*.md

	if use eselect-ldso; then
		insinto /usr/$(get_libdir)/blas/blis
		doins lib/*/lib{c,}blas.so.3
		dosym libblas.so.3 usr/$(get_libdir)/blas/blis/libblas.so
		dosym libcblas.so.3 usr/$(get_libdir)/blas/blis/libcblas.so
	fi
}

pkg_postinst() {
	use eselect-ldso || return

	local libdir=$(get_libdir) me="blis"

	# check blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == "${me}" || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect blas validate
}
