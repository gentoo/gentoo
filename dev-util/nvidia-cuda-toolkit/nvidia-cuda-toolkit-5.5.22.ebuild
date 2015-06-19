# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/nvidia-cuda-toolkit/nvidia-cuda-toolkit-5.5.22.ebuild,v 1.13 2015/02/15 06:50:36 vapier Exp $

EAPI=5

inherit check-reqs cuda unpacker versionator

MYD=$(get_version_component_range 1)_$(get_version_component_range 2)

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="http://developer.nvidia.com/cuda"
CURI="http://developer.download.nvidia.com/compute/cuda/${MYD}/rel/installers"
SRC_URI="
	amd64? ( ${CURI}/cuda_${PV}_linux_64.run )
	x86? ( ${CURI}/cuda_${PV}_linux_32.run )"

SLOT="0/${PV}"
LICENSE="NVIDIA-CUDA"
KEYWORDS="-* amd64 x86 ~amd64-linux ~x86-linux"
IUSE="debugger doc eclipse profiler"

DEPEND=""
RDEPEND="${DEPEND}
	=sys-devel/gcc-4.7*[cxx]
	!<=x11-drivers/nvidia-drivers-270.41
	|| (
		>=x11-drivers/nvidia-drivers-331[uvm]
		<x11-drivers/nvidia-drivers-331
	)
	debugger? (
		sys-libs/libtermcap-compat
		sys-libs/ncurses[tinfo]
		)
	eclipse? ( >=virtual/jre-1.6 )
	profiler? ( >=virtual/jre-1.6 )"

S="${WORKDIR}"

QA_PREBUILT="opt/cuda/*"

CHECKREQS_DISK_BUILD="1500M"

pkg_setup() {
	# We don't like to run cuda_pkg_setup as it depends on us
	check-reqs_pkg_setup
}

src_unpack() {
	unpacker
	unpacker run_files/cuda-linux*.run
}

src_prepare() {
	local cuda_supported_gcc

	cuda_supported_gcc="4.7"

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
		"${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die
}

src_install() {
	local i j
	local remove="doc jre run_files install-linux.pl "
	local cudadir=/opt/cuda
	local ecudadir="${EPREFIX}"${cudadir}

	# dodoc doc/*txt
	if use doc; then
		dodoc doc/pdf/*
		dohtml -r doc/html/*
	fi

	use debugger || remove+=" bin/cuda-gdb extras/Debugger"
	( use profiler || use eclipse ) || remove+=" libnsight"
	use amd64 || remove+=" cuda-installer.pl"

	if use profiler; then
		# hack found in install-linux.pl
		for j in nvvp nsight; do
			cat > bin/${j} <<- EOF
				#!${EPREFIX}/bin/sh
				LD_LIBRARY_PATH=\${LD_LIBRARY_PATH}:${ecudadir}/lib:${ecudadir}/lib64 \
					UBUNTU_MENUPROXY=0 LIBOVERLAY_SCROLLBAR=0 \
					${ecudadir}/lib${j}/${j} -vm ${EPREFIX}/usr/bin/java
			EOF
			chmod a+x bin/${j}
		done
	else
		use eclipse || remove+=" libnvvp"
		remove+=" extras/CUPTI"
	fi

	for i in ${remove}; do
	ebegin "Cleaning ${i}..."
		if [[ -e ${i} ]]; then
			find ${i} -delete || die
			eend
		else
			eend $1
		fi
	done

	dodir ${cudadir}
	mv * "${ED}"${cudadir}

	cat > "${T}"/99cuda <<- EOF
		PATH=${ecudadir}/bin:${ecudadir}/libnvvp
		ROOTPATH=${ecudadir}/bin
		LDPATH=${ecudadir}/lib$(use amd64 && echo "64:${ecudadir}/lib")
	EOF
	doenvd "${T}"/99cuda

	make_wrapper nvprof "${EPREFIX}"${cudadir}/bin/nvprof "." ${ecudadir}/lib$(use amd64 && echo "64:${ecudadir}/lib")

	dobin "${T}"/cuda-config
}

pkg_postinst_check() {
	local a b
	a="$(version_sort $(cuda-config -s))"; a=( $a )
	# greatest supported version
	b=${a[${#a[@]}-1]}

	# if gcc and if not gcc-version is at least greatesst supported
	if [[ $(tc-getCC) == *gcc* ]] && \
		! version_is_at_least $(gcc-version) ${b}; then
			echo
			ewarn "gcc >= ${b} will not work with CUDA"
			ewarn "Make sure you set an earlier version of gcc with gcc-config"
			ewarn "or append --compiler-bindir= pointing to a gcc bindir like"
			ewarn "--compiler-bindir=${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc${b}"
			ewarn "to the nvcc compiler flags"
			echo
	fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_postinst_check
	fi
}
