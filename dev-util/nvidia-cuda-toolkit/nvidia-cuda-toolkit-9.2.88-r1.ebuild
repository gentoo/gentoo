# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs toolchain-funcs unpacker wrapper

MYD=$(ver_cut 1-2 ${PV})
DRIVER_PV="396.26"

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="https://developer.nvidia.com/cuda-zone"
SRC_URI="https://developer.nvidia.com/compute/cuda/${MYD}/Prod/local_installers/cuda_${PV}_${DRIVER_PV}_linux -> cuda_${PV}_${DRIVER_PV}_linux.run"

LICENSE="NVIDIA-CUDA"
SLOT="0/${PV}"
KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE="debugger doc eclipse profiler"
RESTRICT="bindist mirror"

BDEPEND=""
RDEPEND="
	<sys-devel/gcc-8[cxx]
	>=x11-drivers/nvidia-drivers-${DRIVER_PV}
	debugger? (
		sys-libs/libtermcap-compat
		sys-libs/ncurses-compat:5[tinfo]
		)
	eclipse? ( >=virtual/jre-1.8:* )
	profiler? ( >=virtual/jre-1.8:* )"

S="${WORKDIR}"

QA_PREBUILT="opt/cuda/*"

CHECKREQS_DISK_BUILD="3500M"

pkg_setup() {
	check-reqs_pkg_setup
}

src_unpack() {
	unpacker
	unpacker run_files/cuda-linux*.run
}

src_prepare() {
	local cuda_supported_gcc

	# ATTENTION: change requires revbump
	cuda_supported_gcc="4.7 4.8 4.9 5.3 5.4 6.3 6.4 7.2 7.3"

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
		"${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die

	default
}

src_install() {
	local i remove=( doc jre run_files install-linux.pl cuda-installer.pl )
	local cudadir=/opt/cuda
	local ecudadir="${EPREFIX}${cudadir}"

	if use doc; then
		DOCS+=( doc/pdf/. )
		HTML_DOCS+=( doc/html/. )
	fi
	einstalldocs

	mv doc/man/man3/{,cuda-}deprecated.3 || die
	doman doc/man/man*/*

	use debugger || remove+=( bin/cuda-gdb extras/Debugger extras/cuda-gdb-${PV}.src.tar.gz )

	if use profiler; then
		# hack found in install-linux.pl
		for i in nvvp nsight; do
			cat > bin/${i} <<- EOF || die
				#!/usr/bin/env sh
				LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${ecudadir}/lib:${ecudadir}/lib64 \
					UBUNTU_MENUPROXY=0 LIBOVERLAY_SCROLLBAR=0 \
					${ecudadir}/lib${i}/${i} -vm ${EPREFIX}/usr/bin/java
			EOF
			chmod a+x bin/${i} || die
		done
	else
		use eclipse || remove+=( libnvvp libnsight )
		remove+=( extras/CUPTI )
	fi

	for i in "${remove[@]}"; do
		ebegin "Cleaning ${i}..."
		rm -rf "${i}" || die
		eend
	done

	dodir ${cudadir}
	mv * "${ED}${cudadir}" || die

	cat > "${T}"/99cuda <<- EOF || die
		PATH=${ecudadir}/bin$(usex profiler ":${ecudadir}/libnvvp" "")
		ROOTPATH=${ecudadir}/bin
		LDPATH=${ecudadir}/lib64:${ecudadir}/lib:${ecudadir}/nvvm/lib64
	EOF
	doenvd "${T}"/99cuda

	use profiler && \
		make_wrapper nvprof "${ecudadir}/bin/nvprof" "." "${ecudadir}/lib64:${ecudadir}/lib"

	dobin "${T}"/cuda-config
}

pkg_postinst_check() {
	local a b
	a="$(${EROOT}/opt/cuda/bin/cuda-config -s)"
	b="0.0"
	for v in $a; do
		if ver_test "${v}" -gt "${b}"; then
			b="${v}"
		fi
	done

	# if gcc and if not gcc-version is at least greatest supported
	if tc-is-gcc && \
		ver_test $(gcc-version) -gt ${b}; then
			ewarn ""
			ewarn "gcc > ${b} will not work with CUDA"
			ewarn "Make sure you set an earlier version of gcc with gcc-config"
			ewarn "or append --compiler-bindir= pointing to a gcc bindir like"
			ewarn "--compiler-bindir=${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc${b}"
			ewarn "to the nvcc compiler flags"
			ewarn ""
	fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_postinst_check
	fi
}
