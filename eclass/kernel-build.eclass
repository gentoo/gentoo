# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kernel-build.eclass
# @MAINTAINER:
# Distribution Kernel Project <dist-kernel@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: kernel-install
# @BLURB: Build mechanics for Distribution Kernels
# @DESCRIPTION:
# This eclass provides the logic to build a Distribution Kernel from
# source and install it.  Post-install and test logic is inherited
# from kernel-install.eclass.
#
# The ebuild must take care of unpacking the kernel sources, copying
# an appropriate .config into them (e.g. in src_prepare()) and setting
# correct S.  The eclass takes care of respecting savedconfig, building
# the kernel and installing it along with its modules and subset
# of sources needed to build external modules.

if [[ ! ${_KERNEL_BUILD_ECLASS} ]]; then

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

PYTHON_COMPAT=( python3_{8..11} )

inherit multiprocessing python-any-r1 savedconfig toolchain-funcs kernel-install

BDEPEND="
	${PYTHON_DEPS}
	app-arch/cpio
	sys-devel/bc
	sys-devel/flex
	virtual/libelf
	virtual/yacc
"

# @FUNCTION: kernel-build_src_configure
# @DESCRIPTION:
# Prepare the toolchain for building the kernel, get the default .config
# or restore savedconfig, and get build tree configured for modprep.
kernel-build_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	if ! tc-is-cross-compiler && use hppa ; then
		if [[ ${CHOST} == hppa2.0-* ]] ; then
			# Only hppa2.0 can handle 64-bit anyway.
			# Right now, hppa2.0 can run both 32-bit and 64-bit kernels,
			# but it seems like most people do 64-bit kernels now
			# (obviously needed for more RAM too).

			# TODO: What if they want a 32-bit kernel?
			# Not too worried about this case right now.
			elog "Forcing 64 bit (${CHOST/2.0/64}) build..."
			export CHOST=${CHOST/2.0/64}
		fi
	fi

	# force ld.bfd if we can find it easily
	local LD="$(tc-getLD)"
	if type -P "${LD}.bfd" &>/dev/null; then
		LD+=.bfd
	fi

	tc-export_build_env
	MAKEARGS=(
		V=1

		HOSTCC="$(tc-getBUILD_CC)"
		HOSTCXX="$(tc-getBUILD_CXX)"
		HOSTCFLAGS="${BUILD_CFLAGS}"
		HOSTLDFLAGS="${BUILD_LDFLAGS}"

		CROSS_COMPILE=${CHOST}-
		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		LD="${LD}"
		AR="$(tc-getAR)"
		NM="$(tc-getNM)"
		STRIP=":"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"

		# we need to pass it to override colliding Gentoo envvar
		ARCH=$(tc-arch-kernel)
	)

	if type -P xz &>/dev/null ; then
		export XZ_OPT="-T$(makeopts_jobs) --memlimit-compress=50% -q"
	fi

	if type -P zstd &>/dev/null ; then
		export ZSTD_NBTHREADS="$(makeopts_jobs)"
	fi

	# pigz/pbzip2/lbzip2 all need to take an argument, not an env var,
	# for their options, which won't work because of how the kernel build system
	# uses the variables (e.g. passes directly to tar as an executable).
	if type -P pigz &>/dev/null ; then
		MAKEARGS+=( KGZIP="pigz" )
	fi

	if type -P pbzip2 &>/dev/null ; then
		MAKEARGS+=( KBZIP2="pbzip2" )
	elif type -P lbzip2 &>/dev/null ; then
		MAKEARGS+=( KBZIP2="lbzip2" )
	fi

	restore_config .config
	[[ -f .config ]] || die "Ebuild error: please copy default config into .config"

	if [[ -z "${KV_LOCALVERSION}" ]]; then
		KV_LOCALVERSION=$(sed -n -e 's#^CONFIG_LOCALVERSION="\(.*\)"$#\1#p' \
			.config)
	fi

	mkdir -p "${WORKDIR}"/modprep || die
	mv .config "${WORKDIR}"/modprep/ || die
	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" olddefconfig
	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" modules_prepare
	cp -pR "${WORKDIR}"/modprep "${WORKDIR}"/build || die
}

# @FUNCTION: kernel-build_src_compile
# @DESCRIPTION:
# Compile the kernel sources.
kernel-build_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" all
}

# @FUNCTION: kernel-build_src_test
# @DESCRIPTION:
# Test the built kernel via qemu.  This just wraps the logic
# from kernel-install.eclass with the correct paths.
kernel-build_src_test() {
	debug-print-function ${FUNCNAME} "${@}"
	local targets=( modules_install )
	# on arm or arm64 you also need dtb
	if use arm || use arm64; then
		targets+=( dtbs_install )
	fi

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_MOD_PATH="${T}" "${targets[@]}"

	local dir_ver=${PV}${KV_LOCALVERSION}
	local relfile=${WORKDIR}/build/include/config/kernel.release
	local module_ver
	module_ver=$(<"${relfile}") || die

	kernel-install_test "${module_ver}" \
		"${WORKDIR}/build/$(dist-kernel_get_image_path)" \
		"${T}/lib/modules/${module_ver}"
}

# @FUNCTION: kernel-build_src_install
# @DESCRIPTION:
# Install the built kernel along with subset of sources
# into /usr/src/linux-${PV}.  Install the modules.  Save the config.
kernel-build_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	# do not use 'make install' as it behaves differently based
	# on what kind of installkernel is installed
	local targets=( modules_install )
	# on arm or arm64 you also need dtb
	if use arm || use arm64; then
		targets+=( dtbs_install )
	fi

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_MOD_PATH="${ED}" INSTALL_PATH="${ED}/boot" "${targets[@]}"

	# note: we're using mv rather than doins to save space and time
	# install main and arch-specific headers first, and scripts
	local kern_arch=$(tc-arch-kernel)
	local dir_ver=${PV}${KV_LOCALVERSION}
	local kernel_dir=/usr/src/linux-${dir_ver}
	dodir "${kernel_dir}/arch/${kern_arch}"
	mv include scripts "${ED}${kernel_dir}/" || die
	mv "arch/${kern_arch}/include" \
		"${ED}${kernel_dir}/arch/${kern_arch}/" || die
	# some arches need module.lds linker script to build external modules
	if [[ -f arch/${kern_arch}/kernel/module.lds ]]; then
		insinto "${kernel_dir}/arch/${kern_arch}/kernel"
		doins "arch/${kern_arch}/kernel/module.lds"
	fi

	# remove everything but Makefile* and Kconfig*
	find -type f '!' '(' -name 'Makefile*' -o -name 'Kconfig*' ')' \
		-delete || die
	find -type l -delete || die
	cp -p -R * "${ED}${kernel_dir}/" || die

	cd "${WORKDIR}" || die
	# strip out-of-source build stuffs from modprep
	# and then copy built files as well
	find modprep -type f '(' \
			-name Makefile -o \
			-name '*.[ao]' -o \
			'(' -name '.*' -a -not -name '.config' ')' \
		')' -delete || die
	rm modprep/source || die
	cp -p -R modprep/. "${ED}${kernel_dir}"/ || die

	# install the kernel and files needed for module builds
	insinto "${kernel_dir}"
	doins build/{System.map,Module.symvers}
	local image_path=$(dist-kernel_get_image_path)
	cp -p "build/${image_path}" "${ED}${kernel_dir}/${image_path}" || die

	# building modules fails with 'vmlinux has no symtab?' if stripped
	use ppc64 && dostrip -x "${kernel_dir}/${image_path}"

	# Install vmlinux with debuginfo when requested
	if use debug; then
		if [[ "${image_path}" != "vmlinux" ]]; then
			mv "build/vmlinux" "${ED}${kernel_dir}/vmlinux" || die
		fi
		dostrip -x "${kernel_dir}/vmlinux"
	fi

	# strip empty directories
	find "${D}" -type d -empty -exec rmdir {} + || die

	local relfile=${ED}${kernel_dir}/include/config/kernel.release
	local module_ver
	module_ver=$(<"${relfile}") || die

	# fix source tree and build dir symlinks
	dosym "../../../${kernel_dir}" "/lib/modules/${module_ver}/build"
	dosym "../../../${kernel_dir}" "/lib/modules/${module_ver}/source"

	save_config build/.config
}

# @FUNCTION: kernel-build_pkg_postinst
# @DESCRIPTION:
# Combine postinst from kernel-install and savedconfig eclasses.
kernel-build_pkg_postinst() {
	kernel-install_pkg_postinst
	savedconfig_pkg_postinst
}

# @FUNCTION: kernel-build_merge_configs
# @USAGE: [distro.config...]
# @DESCRIPTION:
# Merge the config files specified as arguments (if any) into
# the '.config' file in the current directory, then merge
# any user-supplied configs from ${BROOT}/etc/kernel/config.d/*.config.
# The '.config' file must exist already and contain the base
# configuration.
kernel-build_merge_configs() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -f .config ]] || die "${FUNCNAME}: .config does not exist"
	has .config "${@}" &&
		die "${FUNCNAME}: do not specify .config as parameter"

	local shopt_save=$(shopt -p nullglob)
	shopt -s nullglob
	local user_configs=( "${BROOT}"/etc/kernel/config.d/*.config )
	shopt -u nullglob

	if [[ ${#user_configs[@]} -gt 0 ]]; then
		elog "User config files are being applied:"
		local x
		for x in "${user_configs[@]}"; do
			elog "- ${x}"
		done
	fi

	./scripts/kconfig/merge_config.sh -m -r \
		.config "${@}" "${user_configs[@]}" || die
}

_KERNEL_BUILD_ECLASS=1
fi

EXPORT_FUNCTIONS src_configure src_compile src_test src_install pkg_postinst
