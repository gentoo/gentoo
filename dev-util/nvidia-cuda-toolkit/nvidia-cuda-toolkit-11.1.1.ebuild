# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit check-reqs cuda toolchain-funcs unpacker

DRIVER_PV="455.32.00"

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="https://developer.nvidia.com/cuda-zone"
SRC_URI="https://developer.download.nvidia.com/compute/cuda/${PV}/local_installers/cuda_${PV}_${DRIVER_PV}_linux.run"

LICENSE="NVIDIA-CUDA"
SLOT="0/${PV}"
KEYWORDS="-* ~amd64 ~amd64-linux"
IUSE="debugger nsight profiler vis-profiler sanitizer"
RESTRICT="bindist mirror"

BDEPEND=""
RDEPEND="
	<sys-devel/gcc-11_pre[cxx]
	>=x11-drivers/nvidia-drivers-${DRIVER_PV}[X,uvm]
	debugger? (
		dev-libs/openssl-compat:1.0.0
		sys-libs/libtermcap-compat
		sys-libs/ncurses-compat:5[tinfo]
	)
	vis-profiler? (
		dev-libs/openssl-compat:1.0.0
		>=virtual/jre-1.6
	)"

S="${WORKDIR}"

QA_PREBUILT="opt/cuda/*"

CHECKREQS_DISK_BUILD="6800M"

pkg_setup() {
	# We don't like to run cuda_pkg_setup as it depends on us
	check-reqs_pkg_setup
}

src_prepare() {
	local cuda_supported_gcc

	# ATTENTION: change requires revbump
	cuda_supported_gcc="4.7 4.8 4.9 5.3 5.4 6.3 6.4 7.2 7.3 8.2 8.3 8.4 9.2 9.3 10.2"

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc}:g" \
		"${FILESDIR}"/cuda-config.in > "${T}"/cuda-config || die

	default
}

src_install() {
	local cudadir=/opt/cuda
	local ecudadir="${EPREFIX}${cudadir}"
	dodir ${cudadir}
	into ${cudadir}

	# Install standard sub packages
	local builddirs=(
		builds/cuda_{cudart,cuobjdump,memcheck,nvcc,nvdisasm,nvml_dev,nvprune,nvrtc,nvtx}
		builds/lib{cublas,cufft,curand,cusolver,cusparse,npp,nvjpeg}
		$(usex profiler "builds/cuda_nvprof builds/cuda_cupti" "")
		$(usex vis-profiler "builds/cuda_nvvp" "")
		$(usex debugger "builds/cuda_gdb" "")
	)

	local d
	for d in "${builddirs[@]}"; do
		ebegin "Installing ${d}"
		[[ -d ${d} ]] || die "Directory does not exist: ${d}"

		if [[ -d ${d}/bin ]]; then
			local f
			for f in ${d}/bin/*; do
				if [[ -f ${f} ]]; then
					dobin "${f}"
				else
					insinto ${cudadir}/bin
					doins -r "${f}"
				fi
			done
		fi

		insinto ${cudadir}
		if [[ -d ${d}/targets ]]; then
			doins -r "${d}"/targets
		fi
		if [[ -d ${d}/share ]]; then
			doins -r "${d}"/share
		fi
		if [[ -d ${d}/extras ]]; then
			doins -r "${d}"/extras
		fi
		eend
	done
	dobin "${T}"/cuda-config

	doins builds/EULA.txt
	# nvml and nvvm need special handling
	ebegin "Installing nvvm"
	doins -r builds/cuda_nvcc/nvvm
	exeinto ${cudadir}/nvvm/bin
	doexe builds/cuda_nvcc/nvvm/bin/cicc
	eend

	ebegin "Installing nvml"
	doins -r builds/cuda_nvml_dev/nvml
	eend

	if use sanitizer; then
		ebegin "Installing sanitizer"
		dobin builds/integration/Sanitizer/compute-sanitizer
		doins -r builds/cuda_sanitizer_api/Sanitizer
		# special handling for the executable
		exeinto ${cudadir}/Sanitizer
		doexe builds/cuda_sanitizer_api/Sanitizer/compute-sanitizer
		eend
	fi

	if use vis-profiler; then
		ebegin "Installing libnvvp"
		doins -r builds/cuda_nvvp/libnvvp
		# special handling for the executable
		exeinto ${cudadir}/libnvvp
		doexe builds/cuda_nvvp/libnvvp/nvvp
		eend
	fi

	if use nsight; then
		local ncu_dir=$(grep -o 'nsight-compute-[0-9][0-9\.]*' -m1 manifests/cuda_x86_64.xml)
		ebegin "Installing ${ncu_dir}"
		mv builds/nsight_compute builds/${ncu_dir} || die
		doins -r builds/${ncu_dir}

		exeinto ${cudadir}/${ncu_dir}
		doexe builds/${ncu_dir}/{ncu,ncu-ui,nv-nsight-cu,nv-nsight-cu-cli}

		exeinto ${cudadir}/${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64
		doexe builds/${ncu_dir}/host/linux-desktop-glibc_2_11_3-x64/{ncu-ui,ncu-ui.bin,CrashReporter}
		dobin builds/integration/nsight-compute/{ncu,ncu-ui,nv-nsight-cu,nv-nsight-cu-cli}
		eend

		local nsys_dir=$(grep -o 'nsight-systems-[0-9][0-9\.]*' -m1 manifests/cuda_x86_64.xml)
		ebegin "Installing ${nsys_dir}"
		mv builds/nsight_systems builds/${nsys_dir} || die
		doins -r builds/${nsys_dir}
		exeinto ${cudadir}/${nsys_dir}/target-linux-x64
		doexe builds/${nsys_dir}/target-linux-x64/nsys

		exeinto ${cudadir}/${nsys_dir}/host-linux-x64
		doexe builds/${nsys_dir}/host-linux-x64/{nsight-sys,nsight-sys.bin,nsys-ui,CrashReporter,ImportNvtxt,QdstrmImporter,ResolveSymbols}
		dobin builds/integration/nsight-systems/{nsight-sys,nsys,nsys-exporter,nsys-ui}
		eend
		# TODO: unbundle qt5
		# TODO: unbundle boost
		# TODO: unbundle icu
		# TODO: unbundle openssl
		# TODO: unbundle mesa
		# TODO: unbundle libz
		# TODO: unbundle libstdc++
		# TODO: unbundle libSshClient
		# TODO: unbundle sqlite
		# TODO: unbundle libpfm ?
	fi

	# Add include and lib symlinks
	dosym "targets/x86_64-linux/include" ${cudadir}/include
	dosym "targets/x86_64-linux/lib" ${cudadir}/lib64

	newenvd - 99cuda <<-EOF
		PATH=${ecudadir}/bin$(usex vis-profiler ":${ecudadir}/libnvvp" "")
		ROOTPATH=${ecudadir}/bin
		LDPATH=${ecudadir}/lib64:${ecudadir}/nvvm/lib64$(usex profiler ":${ecudadir}/extras/CUPTI/lib64" "")
	EOF

	# Cuda prepackages libraries, don't revdep-build on them
	insinto /etc/revdep-rebuild
	newins - 80${PN} <<-EOF
		SEARCH_DIRS_MASK="${ecudadir}"
	EOF
	# TODO: Find a better way to add +x permission to installed executables
	# TODO: Add pkgconfig files for installed libraries
}

pkg_postinst_check() {
	local a="$(${EROOT}/opt/cuda/bin/cuda-config -s)"
	local b="0.0"
	local v
	for v in ${a}; do
		ver_test "${v}" -gt "${b}" && b="${v}"
	done

	# if gcc and if not gcc-version is at least greatest supported
	if tc-is-gcc && \
		ver_test $(gcc-version) -gt "${b}"; then
			ewarn
			ewarn "gcc > ${b} will not work with CUDA"
			ewarn "Make sure you set an earlier version of gcc with gcc-config"
			ewarn "or append --compiler-bindir= pointing to a gcc bindir like"
			ewarn "--compiler-bindir=${EPREFIX}/usr/*pc-linux-gnu/gcc-bin/gcc${b}"
			ewarn "to the nvcc compiler flags"
			ewarn
	fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_postinst_check
	fi

	if use profiler || use nsight; then
		einfo
		einfo "nvidia-drivers restrict access to performance counters."
		einfo "You'll need to either run profiling tools (nvprof, nsight) "
		einfo "using sudo (needs cap SYS_ADMIN) or add the following line to "
		einfo "a modprobe configuration file "
		einfo "(e.g. /etc/modprobe.d/nvidia-prof.conf): "
		einfo
		einfo "options nvidia NVreg_RestrictProfilingToAdminUsers=0"
		einfo
	fi
}
