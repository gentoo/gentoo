# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2317

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
inherit check-reqs edo toolchain-funcs
inherit python-r1

DRIVER_PV="560.35.05"
GCC_MAX_VER="13"
CLANG_MAX_VER="18"

DESCRIPTION="NVIDIA CUDA Toolkit (compiler and friends)"
HOMEPAGE="https://developer.nvidia.com/cuda-zone"
SRC_URI="
	amd64? (
		https://developer.download.nvidia.com/compute/cuda/${PV}/local_installers/cuda_${PV}_${DRIVER_PV}_linux.run
	)
	arm64? (
		https://developer.download.nvidia.com/compute/cuda/${PV}/local_installers/cuda_${PV}_${DRIVER_PV}_linux_sbsa.run
	)
"
S="${WORKDIR}"

LICENSE="NVIDIA-CUDA"

SLOT="0/${PV}" # UNSLOTTED
# SLOT="${PV}" # SLOTTED

KEYWORDS="-* ~amd64 ~arm64 ~amd64-linux ~arm64-linux"
IUSE="clang debugger examples nsight profiler rdma sanitizer"
RESTRICT="bindist mirror strip test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# since CUDA 11, the bundled toolkit driver (== ${DRIVER_PV}) and the
# actual required minimum driver version are different.
RDEPEND="
	!clang? (
		<sys-devel/gcc-$(( GCC_MAX_VER + 1 ))_pre[cxx]
	)
	clang? (
		<llvm-core/clang-$(( CLANG_MAX_VER + 1 ))_pre
	)
	sys-process/numactl
	debugger? (
		${PYTHON_DEPS}
	)
	examples? (
		media-libs/freeglut
		media-libs/glu
	)
	nsight? (
		dev-util/nsight-compute
		dev-util/nsight-systems
	)
	rdma? (
		sys-cluster/rdma-core
	)
"
BDEPEND="
	$(python_gen_any_dep '
		dev-python/defusedxml[${PYTHON_USEDEP}]
	')
"

# CUDA_PATH="/opt/cuda-${PV}" #950207
CUDA_PATH="/opt/cuda"
QA_PREBUILT="${CUDA_PATH#/}/*"

python_check_deps() {
	python_has_version "dev-python/defusedxml[${PYTHON_USEDEP}]"
}

cuda-toolkit_check_reqs() {
	if use amd64; then
		export CHECKREQS_DISK_BUILD="4908M"
	elif use arm64; then
		export CHECKREQS_DISK_BUILD="4852M"
	fi

	"check-reqs_pkg_${EBUILD_PHASE}"
}

cuda_verify() {
	# only works with unpacked sources
	[[ "${EBUILD_PHASE}" != prepare ]] && return

	# run self checks
	local compiler_versions GCC_HAS_VER CLANG_HAS_VER
	compiler_versions="$(
		grep -oP "unsupported (GNU|clang) version.*(gcc versions later than|clang version must be less than) [0-9]*" \
			"${S}"/builds/cuda_nvcc/targets/*/include/crt/host_config.h
	)"

	GCC_HAS_VER="$( echo "${compiler_versions}" | grep gcc | grep -oP "(?<=than )[0-9]*")"
	if [[ "${GCC_MAX_VER}" -ne "${GCC_HAS_VER}" ]]; then
		eqawarn "check GCC_MAX_VER is ${GCC_MAX_VER} and should be ${GCC_HAS_VER}"
	fi

	CLANG_HAS_VER="$(( $(echo "${compiler_versions}" | grep clang | grep -oP "(?<=than )[0-9]*") - 1 ))"
	if [[ "${CLANG_MAX_VER}" -ne "${CLANG_HAS_VER}" ]]; then
		eqawarn "check CLANG_MAX_VER is ${CLANG_MAX_VER} and should be ${CLANG_HAS_VER}"
	fi
}

pkg_pretend() {
	cuda-toolkit_check_reqs
}

pkg_setup() {
	cuda-toolkit_check_reqs

	if [[ "${MERGE_TYPE}" == binary ]]; then
		return
	fi

	# we need python for manifest parsing and to determine the supported python versions for cuda-gdb
	python_setup

	if use amd64; then
		narch=x86_64
	elif use arm64; then
		narch=sbsa
	else
		die "unknown arch ${ARCH}"
	fi

	export narch
}

src_unpack() {
	cuda_verify

	local exclude=(
		"cuda-installer"
		"*-uninstaller"
		"NVIDIA-Linux-${narch}-${DRIVER_PV}.run"
		"builds/cuda_documentation"
		"builds/cuda_nsight"
		"builds/cuda_nvvp"
		"builds/nsight_compute"
		"builds/nsight_systems"
		"builds/nvidia_fs"
	)

	edob -m "Extracting ${A}" \
		bash "${DISTDIR}/${A}" --tar xf -X <(printf "%s\n" "${exclude[@]}")
}

src_prepare() {
	pushd "builds/cuda_nvcc/targets/${narch}-linux" >/dev/null || die
	eapply -p5 "${FILESDIR}/nvidia-cuda-toolkit-glibc-2.41-r1.patch"
	popd >/dev/null || die

	default
}

src_configure() {
	:
}

src_compile() {
	:
}

src_install() {
	local -x SKIP_COMPONENTS=(
		"Kernel_Objects"
		"Visual_Tools"
		"Documentation"  # obsolete
		"cuda-gdb-src"   # not used
	)

	! use debugger     && SKIP_COMPONENTS+=( "cuda-gdb" )
	! use examples     && SKIP_COMPONENTS+=( "Demo_Suite" )
	! use profiler     && SKIP_COMPONENTS+=( "cuda-cupti" "cuda-profiler-api" "nvprof" )
	! use sanitizer    && SKIP_COMPONENTS+=( "compute-sanitizer" )

	dodir "${CUDA_PATH}"
	into "${CUDA_PATH}"

	dofile() {
		debug-print-function "${FUNCNAME[0]}" "$@"

		if [[ $# -ne 1 ]] && [[ $# -ne 2 ]]; then
			die "${FUNCNAME[0]} must receive one or two arguments"
		fi

		local _DESTDIR
		_DESTDIR="$(dirname "${CUDA_PATH}/${1%/}")${2:+/${2%/}}"
		mkdir -p "${ED}${_DESTDIR}" || die "mkdir ${_DESTDIR} failed"

		local dir
		dir="$(dirname "${1}")"

		if test -z "$(find "${dir}" -maxdepth 1 -name "$(basename "$1")" -print -quit)"; then
			if [[ -e "${ED}${_DESTDIR}/$(basename "${1}")" ]]; then
				return
			fi
			if [[ "$1" == "targets/x86_64-linux/lib/stubs/libcusolverMg*" ]] ||
				[[ "$1" == "targets/x86_64-linux/lib/libcusparse.so.*" ]]; then
				return
			fi
			return
		fi

		if [[ -e "${ED}${_DESTDIR}/$(basename "${1}")" ]]; then
			# skip noisy warnings
			if [[ "$(basename "${1}")" == "include" ]] ||
				[[ "$(basename "${1}")" == "lib64" ]]; then
				return
			fi
			eqawarn "${ED}${_DESTDIR}/$(basename "${1}") exists"
			return
		fi

		eval mv -i "${1}" "${ED}${_DESTDIR}" || die "mv failed ${PWD} / ${1} -> ${ED} ${_DESTDIR}"
	}

	dopcfile() {
		[[ $# -eq 0 ]] && return

		dodir "${CUDA_PATH}/pkgconfig"
		cat > "${ED}${CUDA_PATH}/pkgconfig/${1}.pc" <<-EOF || die "dopcfile"
			cudaroot=${EPREFIX}${CUDA_PATH}
			libdir=\${cudaroot}/targets/${narch}-linux/lib${4}
			includedir=\${cudaroot}/targets/${narch}-linux/include

			Name: ${1}
			Description: ${3}
			Version: ${2}
			Libs: -L\${libdir} -l${1}
			Cflags: -I\${includedir}
		EOF
	}

	pushd builds >/dev/null || die
	fix_executable_bit=(
		cuda_cupti/extras/CUPTI/samples/pc_sampling_utility/pc_sampling_utility_helper.h
		cuda_cupti/extras/CUPTI/samples/pc_sampling_continuous/libpc_sampling_continuous.pl

		libcufile/gds/tools/run_gdsio.cfg
	)

	if use amd64; then
		fix_executable_bit+=(
			cuda_opencl/targets/*/include/CL/cl.hpp

			libcufile/targets/*/lib/libcufile_rdma_static.a
			libcufile/targets/*/lib/libcufile_static.a
		)
	fi
	chmod -x "${fix_executable_bit[@]}" || die "failed chmod"
	popd >/dev/null || die

	ebegin "parsing manifest" "${S}/manifests/cuda_"*.xml # {{{

	"${EPYTHON}" "${FILESDIR}/parse_manifest.py" "${S}/manifests/cuda_"*".xml" &> "${T}/install.sh" \
		|| die "failed to parse manifest"
	# shellcheck disable=SC1091
	source "${T}/install.sh" || die "failed  to source install script"

	eend $? # }}}

	if use debugger; then
		if [[ -d "${ED}/${CUDA_PATH}/extras/Debugger/lib64" ]]; then
			rmdir "${ED}/${CUDA_PATH}/extras/Debugger/lib64" || die "remove debugger lib64"
		fi

		find "${ED}/${CUDA_PATH}/bin" -maxdepth 1 -name "cuda-gdb-*-tui" -print0 | while read -rd $'\0' tui_name; do
			impl="$(basename "${tui_name}" | cut -d '-' -f 3 | tr '.' '_')"

			if ! has "${impl}" "${PYTHON_COMPAT[@]}" || ! use "python_targets_${impl}"; then
				rm "${tui_name}" || die "tui-name rm ${tui_name}"
				sed -e "/$(basename "${tui_name}")\"/d" -i "${ED}/${CUDA_PATH}/bin/cuda-gdb" || die "tui_name sed"
			fi
		done
	fi

	# remove rdma libs (unless USE=rdma)
	if ! use rdma; then
		rm "${ED}/${CUDA_PATH}/targets/${narch}-linux/lib/libcufile_rdma"* || die "failed to remove rdma files"
	fi

	# Add include and lib symlinks
	dosym -r "${CUDA_PATH}/targets/${narch}-linux/include" "${CUDA_PATH}/include"
	dosym -r "${CUDA_PATH}/targets/${narch}-linux/lib" "${CUDA_PATH}/$(get_libdir)"

	find "${ED}/${CUDA_PATH}" -empty -delete || die

	local ldpathextradirs pathextradirs

	use debugger && ldpathextradirs+=":${EPREFIX}${CUDA_PATH}/extras/Debugger/lib64"
	use profiler && ldpathextradirs+=":${EPREFIX}${CUDA_PATH}/extras/CUPTI/lib64"

	local revord=$(( 999999 - $(printf "%02d%02d%02d" "$(ver_cut 1)" "$(ver_cut 2)" "$(ver_cut 3)") ))
	newenvd - "99cuda${revord}" <<-EOF
		PATH=${EPREFIX}${CUDA_PATH}/bin${pathextradirs}
		PKG_CONFIG_PATH=${EPREFIX}${CUDA_PATH}/pkgconfig
		LDPATH=${EPREFIX}${CUDA_PATH}/$(get_libdir):${EPREFIX}${CUDA_PATH}/nvvm/lib64${ldpathextradirs}
	EOF

	# CUDA prepackages libraries, don't revdep-build on them
	insinto /etc/revdep-rebuild
	newins - "80${PN}${revord}" <<-EOF
		SEARCH_DIRS_MASK="${EPREFIX}${CUDA_PATH}"
	EOF

	# https://bugs.gentoo.org/926116
	insinto /etc/sandbox.d
	newins - "80${PN}" <<-EOF
		SANDBOX_PREDICT="/proc/self/task"
	EOF

	# TODO drop and replace with runtime detection similar to what python does {{{
	# ATTENTION: change requires revbump, see link below for supported GCC # versions
	# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#system-requirements
	local cuda_supported_gcc=( 8.5 9.5 10 11 12 13 "${GCC_MAX_VER}" )

	sed \
		-e "s:CUDA_SUPPORTED_GCC:${cuda_supported_gcc[*]}:g" \
		"${FILESDIR}"/cuda-config.in > "${ED}/${CUDA_PATH}/bin/cuda-config" || die
	fperms +x "${CUDA_PATH}/bin/cuda-config"
	# }}}

	# skip til cudnn has been changed #950207
	# if [[ "${SLOT}" != "${PV}" ]]; then
	# 	dosym -r "${CUDA_PATH}" "${CUDA_PATH%"-${PV}"}"
	# fi

	fowners -R root:root "${CUDA_PATH}"
}

pkg_postinst_check() {
	if tc-is-gcc &&
		ver_test "$(gcc-major-version)" -gt "${GCC_MAX_VER}"; then
			ewarn
			ewarn "gcc > ${GCC_MAX_VER} will not work with CUDA"
			ewarn
			ewarn "Append --ccbin= pointing to a gcc bindir to the nvcc compiler flags (NVCCFLAGS)"
			ewarn "or set NVCC_CCBIN to the same bindir."
			ewarn "	NVCCFLAGS=\"--ccbin=$(eval echo "${EPREFIX}/usr/*-linux-gnu/gcc-bin/${GCC_MAX_VER}")\""
			ewarn "	NVCC_CCBIN=$(eval echo "${EPREFIX}/usr/*-linux-gnu/gcc-bin/${GCC_MAX_VER}")"
			ewarn
	fi

	if tc-is-clang &&
		ver_test "$(clang-major-version)" -gt "${CLANG_MAX_VER}"; then
			ewarn
			ewarn "clang > ${CLANG_MAX_VER} will not work with CUDA"
			ewarn
			ewarn "Append --ccbin= pointing to a clang bindir to the nvcc compiler flags (NVCCFLAGS)"
			ewarn "or set NVCC_CCBIN to the same bindir."
			ewarn "	NVCCFLAGS=\"--ccbin=$(eval echo "${EPREFIX}/usr/lib/llvm/*/bin${CLANG_MAX_VER}")\""
			ewarn "	NVCC_CCBIN=$(eval echo "${EPREFIX}/usr/lib/llvm/*/bin${CLANG_MAX_VER}")"
			ewarn
	fi
}

pkg_postinst() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		pkg_postinst_check
	fi

	if use profiler; then
		einfo
		einfo "nvidia-drivers restricts access to performance counters."
		einfo "You'll need to run profiling tools (nvprof) "
		einfo "using sudo (needs cap SYS_ADMIN) or add the following line to "
		einfo "a modprobe configuration file "
		einfo "(e.g. /etc/modprobe.d/nvidia-prof.conf): "
		einfo
		einfo "options nvidia NVreg_RestrictProfilingToAdminUsers=0"
		einfo
	fi
}
