# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs multibuild pax-utils

DESCRIPTION="Standard ML optimizing compiler and libraries"
BASE_URI="mirror://sourceforge/${PN}"
SRC_URI="!binary? ( ${BASE_URI}/${P}.src.tgz )
		  !bootstrap-smlnj? ( amd64? ( ${BASE_URI}/${P}-1.amd64-linux.tgz ) )"
HOMEPAGE="http://www.mlton.org"

LICENSE="HPND MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="binary bootstrap-smlnj stage3 doc pax_kernel"

DEPEND="dev-libs/gmp:*
		bootstrap-smlnj? ( dev-lang/smlnj )
		!bootstrap-smlnj? (
			!amd64?  ( dev-lang/smlnj )
		)
		pax_kernel? ( sys-apps/elfix )
		doc? ( virtual/latex-base )"
RDEPEND="dev-libs/gmp:*"

QA_PRESTRIPPED="binary? (
	usr/lib64/${PN}/bin/mlnlffigen
	usr/lib64/${PN}/bin/mllex
	usr/lib64/${PN}/bin/mlprof
	usr/lib64/${PN}/bin/mlyacc
	usr/lib64/${PN}/lib/mlton-compile
	usr/lib/${PN}/bin/mlnlffigen
	usr/lib/${PN}/bin/mllex
	usr/lib/${PN}/bin/mlprof
	usr/lib/${PN}/bin/mlyacc
	usr/lib/${PN}/lib/mlton-compile
)"

B="${P}-1.${ARCH}-${KERNEL}"
R="${WORKDIR}/${B}"

mlton_subdir() {
	echo $(get_libdir)/${PN}
}

mlton_dir() {
	echo "${EPREFIX}"/usr/$(mlton_subdir)
}

mlton_memory_requirement() {
	# The resident set size of compiling mlton with mlton is almost 14GB on amd64.
	# http://mlton.org/SelfCompiling
	# Compiling MLton requires at least 1GB of RAM for 32-bit platforms (2GB is
	# preferable) and at least 2GB RAM for 64-bit platforms (4GB is preferable).
	# If your machine has less RAM, self-compilation will likely fail, or at least
	# take a very long time due to paging. Even if you have enough memory, there
	# simply may not be enough available, due to memory consumed by other
	# processes. In this case, you may see an Out of memory message, or
	# self-compilation may become extremely slow. The only fix is to make sure
	# that enough memory is available.
	[[ ${ARCH} == "x86" ]] && echo "2G" || echo "4G"
}

pkg_pretend() {
	if use !binary; then
		local CHECKREQS_MEMORY=$(mlton_memory_requirement)
		check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	if use !binary; then
		local CHECKREQS_MEMORY=$(mlton_memory_requirement)
		check-reqs_pkg_setup
	fi
}

mlton_bootstrap_variant() {
	local b=""
	if use bootstrap-smlnj || ! use amd64; then
		b="bootstrap-smlnj"
	else
		b="bootstrap"
	fi
	echo "${b}"
}

mlton_bootstrap_build_dir() {
	echo $(basename ${S})"-"$(mlton_bootstrap_variant)
}

mlton_bootstrap_bin_dir() {
	local b=$(mlton_bootstrap_build_dir)
	if use bootstrap-smlnj || ! use amd64; then
		b+="/build/bin"
	else
		b+="/bin"
	fi
	echo "${b}"
}

# Return the array of multilib build variants
mlton_multibuild_variants() {
	local MULTIBUILD_VARIANTS=()
	if ! use binary; then
		if use bootstrap-smlnj || ! use amd64; then
			MULTIBUILD_VARIANTS+=( $(mlton_bootstrap_variant) )
			use stage3 && MULTIBUILD_VARIANTS+=( build-with-mlton )
		else
			MULTIBUILD_VARIANTS+=( build-with-mlton )
		fi
	fi
	echo ${MULTIBUILD_VARIANTS[*]}
}

# Return the last multibuild variant
mlton_last_multibuild_variant() {
	local vs=( $(mlton_multibuild_variants) )
	echo ${vs[${#vs[@]}-1]}
}

src_unpack() {
	default
	if use binary; then
		mkdir -p "${S}" || die
	fi
}

BIN_STUBS=( mllex mlnlffigen mlprof mlton mlyacc )

mlton_create_bin_stubs() {
	local SUBDIR=$(mlton_subdir)
	mkdir "${S}"/bin_stubs || die
	pushd "${S}"/bin_stubs || die
	for i in ${BIN_STUBS[*]}; do
		cat <<- EOF >> ${i}
			#!/bin/bash
			exec ${EPREFIX}/usr/${SUBDIR}/bin/${i} \$*
		EOF
		chmod a+x ${i} || die
	done
	popd || die
}

src_prepare() {
	if ! use binary; then
		# For Gentoo hardened: paxmark the mlton-compiler, mllex and mlyacc executables
		eapply "${FILESDIR}/${PN}-20180207-paxmark.patch"
		# Fix the bootstrap-smlnj and bootstrap-polyml Makefile targets
		eapply "${FILESDIR}/${PN}-20180207-bootstrap.patch"
	fi

	default

	$(mlton_create_bin_stubs)

	if use binary; then
		pax-mark m "${R}/lib/${PN}/mlton-compile"
		pax-mark m "${R}/bin/mllex"
		pax-mark m "${R}/bin/mlyacc"
		ln -s ${R} ../$(mlton_bootstrap_build_dir) || die
		gunzip ${R}/share/man/man1/*.gz || die
	else
		local MULTIBUILD_VARIANTS=( $(mlton_multibuild_variants) )
		multibuild_copy_sources
		if ! use bootstrap-smlnj && [[ ${ARCH} == "amd64" ]]; then
			ln -s ${B} ../$(mlton_bootstrap_build_dir) || die
		fi
	fi
}

mlton_src_compile() {
	if [[ ${MULTIBUILD_VARIANT} == $(mlton_bootstrap_variant) ]]; then
		emake -j1 \
			"bootstrap-smlnj" \
			PAXMARK=$(usex pax_kernel "paxmark.sh" "true") \
			CFLAGS="${CFLAGS}" \
			WITH_GMP_INC_DIR="${EPREFIX}"/usr/include \
			WITH_GMP_LIB_DIR="${EPREFIX}"/$(get_libdir)
	else
		export PATH="${WORKDIR}/"$(mlton_bootstrap_bin_dir)":${PATH}"
		einfo "${MULTIBUILD_VARIANT}: Building mlton with mlton in PATH=$PATH"
		emake -j1 \
			CFLAGS="${CFLAGS}" \
			WITH_GMP_INC_DIR="${EPREFIX}"/usr/include \
			WITH_GMP_LIB_DIR="${EPREFIX}"/$(get_libdir)
	fi
	if [[ ${MULTIBUILD_VARIANT} == $(mlton_last_multibuild_variant) ]]; then
		if use doc; then
			export VARTEXFONTS="${T}/fonts"
			emake docs
		fi
	fi
}

src_compile() {
	if ! use binary; then
		local MULTIBUILD_VARIANTS=( $(mlton_multibuild_variants) )
		multibuild_foreach_variant run_in_build_dir mlton_src_compile
	fi
}

mlton_src_test() {
	emake check
}

src_test() {
	if ! use binary; then
		local MULTIBUILD_VARIANTS=( $(mlton_last_multibuild_variant) )
		multibuild_foreach_variant run_in_build_dir mlton_src_test
	fi
}

mlton_src_install() {
	local DIR=$(mlton_dir)
	emake \
		install-no-strip install-strip \
		DESTDIR="${D}" \
		PREFIX="${DIR}"
	if use doc; then
		emake TDOC="${D}"/usr/share/doc/${PF} install-docs \
			DESTDIR="${D}" \
			PREFIX="${DIR}"
	fi
}

mlton_install_bin_stubs() {
	exeinto /usr/bin
	for i in ${BIN_STUBS[*]}; do
		doexe "${S}"/bin_stubs/${i}
	done
}

src_install() {
	$(mlton_install_bin_stubs)
	if use binary; then
		local DIR=$(mlton_dir)
		exeinto "${DIR}"/bin
		doexe "${R}"/bin/*
		insinto "${DIR}"/lib
		doins -r "${R}"/lib/${PN}
		exeinto "${DIR}"/lib/${PN}
		doexe "${R}"/lib/${PN}/mlton-compile
		doman "${R}"/share/man/man1/*
		if use doc; then
			local DOCS=( "${R}"/share/doc/${PN}/. )
			einstalldocs
		fi
	else
		local MULTIBUILD_VARIANTS=( $(mlton_last_multibuild_variant) )
		multibuild_foreach_variant run_in_build_dir mlton_src_install
	fi
}

pkg_postinst() {
	# There are PIC objects in libmlton-pic.a. -link-opt -lmlton-pic does not help as mlton
	# specifies -lmlton before -lmlton-pic. It appears that it would be necessary to patch mlton
	# to convince mlton to use the lib*-pic.a libraries when linking an executable.
	ewarn 'PIE in Gentoo hardened requires executables to be linked with -fPIC. mlton by default links'
	ewarn 'executables against the non PIC objects in libmlton.a.  http://mlton.org/MLtonWorld notes:'
	ewarn 'Executables that save and load worlds are incompatible with address space layout'
	ewarn 'randomization (ASLR) of the executable.'
	ewarn 'To suppress the generation of position-independent executables.'
	ewarn '-link-opt -fno-PIE'
}
