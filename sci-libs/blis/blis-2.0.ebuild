# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit python-any-r1 toolchain-funcs

DESCRIPTION="BLAS-like Library Instantiation Software Framework"
HOMEPAGE="https://github.com/flame/blis"
SRC_URI="https://github.com/flame/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
# SOVERSION; but 2.0 introduced some breaking changes
SLOT="0/4-2.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
CPU_USE=(
	cpu_flags_ppc_{vsx,vsx3}
	cpu_flags_arm_{neon,v7,v8,sve}
	cpu_flags_x86_{ssse3,avx,fma3,fma4,avx2,avx512vl}
)
IUSE="doc eselect-ldso index64 openmp pthread serial static-libs ${CPU_USE[@]}"
REQUIRED_USE="?? ( openmp pthread serial )"

DEPEND="
	eselect-ldso? (
		!app-eselect/eselect-cblas
		>=app-eselect/eselect-blas-0.2
	)
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
"

PATCHES=(
	# TODO: remove this when we remove eselect-ldso
	"${FILESDIR}"/${PN}-0.6.0-blas-provider.patch
	# to prevent QA Notice: pkg-config files with wrong LDFLAGS detected
	"${FILESDIR}"/${PN}-0.8.1-pkg-config.patch
	"${FILESDIR}"/${PN}-0.9.0-rpath.patch
	"${FILESDIR}"/${PN}-1.0-no-helper-headers.patch
	# https://github.com/flame/blis/pull/891
	"${FILESDIR}"/${P}-gcc16.patch
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
	# This is not an autotools configure file. We don't use econf here.
	local myconf=(
		--enable-verbose-make
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable static-libs static)
		--enable-blas
		--enable-cblas
		--enable-shared
	)
	if use openmp; then
		myconf+=( -t openmp )
	elif use pthread; then
		myconf+=( -t pthreads )
	else
		myconf+=( -t no )
	fi
	# confname must always come last
	myconf+=( "$(get_confname)" )

	local -x CC="$(tc-getCC)"
	local -x AR="$(tc-getAR)"
	local -x RANLIB="$(tc-getRANLIB)"

	if use index64; then
		einfo "Configuring ILP64 variant"
		cp -r "${S}" "${S}-ilp64" || die
		pushd "${S}-ilp64" >/dev/null || die
		./configure -b 64 -i 64 "${myconf[@]}" || die
		popd >/dev/null || die
	fi

	einfo "Configuring LP64 variant"
	./configure "${myconf[@]}" || die
}

emake64() {
	local overrides=(
		LIBBLIS=libblis64
		MK_INCL_DIR_INST="${ED}/usr/include/blis64"
	)

	emake -C "${S}-ilp64" "${overrides[@]}" "${@}"
}

src_compile() {
	local -x DEB_LIBBLAS=libblas.so.3
	local -x DEB_LIBCBLAS=libcblas.so.3
	local -x LDS_BLAS="${FILESDIR}"/blas.lds
	local -x LDS_CBLAS="${FILESDIR}"/cblas.lds
	use index64 && emake64
	emake
}

src_test() {
	local -x LD_LIBRARY_PATH="lib/$(get_confname)"
	emake testblis-fast
	./testsuite/check-blistest.sh ./output.testsuite || die
	if use index64; then
		emake64 testblis-fast
		./testsuite/check-blistest.sh "${S}-ilp64"/output.testsuite || die
	fi
}

src_install() {
	local libroot=/usr/$(get_libdir)
	local install_args=(
		DESTDIR="${D}"
		# remove weird Makefile configs, they're incorrect for index64
		# and nothing should be using them anyway
		MK_SHARE_DIR_INST="${T}/discard"
		# upstream installs .pc file to share, sigh
		PC_SHARE_DIR_INST="${ED}${libroot}/pkgconfig"
	)
	emake "${install_args[@]}" install
	if use index64; then
		emake64 "${install_args[@]}" install
		# we need to make blis64.pc with proper subst ourselves
		sed -e 's:blis:&64:' "${ED}${libroot}/pkgconfig"/blis.pc \
			> "${ED}${libroot}/pkgconfig"/blis64.pc || die
	fi
	use doc && dodoc README.md docs/*.md

	if use eselect-ldso; then
		insinto "${libroot}/blas/blis"
		doins lib/*/lib{c,}blas.so.3
		dosym libblas.so.3 "${libroot}/blas/blis/libblas.so"
		dosym libcblas.so.3 "${libroot}/blas/blis/libcblas.so"
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
		elog "Current eselect: BLAS/CBLAS (${libdir}) -> [${me}]."
	else
		elog "Current eselect: BLAS/CBLAS (${libdir}) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso && eselect blas validate
}
