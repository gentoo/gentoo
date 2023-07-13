# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kernel-build.eclass
# @MAINTAINER:
# Distribution Kernel Project <dist-kernel@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 8
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

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_KERNEL_BUILD_ECLASS} ]]; then
_KERNEL_BUILD_ECLASS=1

PYTHON_COMPAT=( python3_{10..12} )
if [[ ${KERNEL_IUSE_MODULES_SIGN} ]]; then
	# If we have enabled module signing IUSE
	# then we can also enable secureboot IUSE
	KERNEL_IUSE_SECUREBOOT=1
fi

inherit multiprocessing python-any-r1 savedconfig toolchain-funcs kernel-install

BDEPEND="
	${PYTHON_DEPS}
	app-arch/cpio
	sys-devel/bc
	sys-devel/flex
	virtual/libelf
	app-alternatives/yacc
	arm? ( sys-apps/dtc )
	arm64? ( sys-apps/dtc )
	riscv? ( sys-apps/dtc )
"

IUSE="+strip"

# @ECLASS_VARIABLE: KERNEL_IUSE_MODULES_SIGN
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to a non-null value, adds IUSE=modules-sign and required
# logic to manipulate the kernel config while respecting the
# MODULES_SIGN_HASH and MODULES_SIGN_KEY user variables.

# @ECLASS_VARIABLE: MODULES_SIGN_HASH
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=modules-sign.  Can be set to hash algorithm to use
# during signature generation (CONFIG_MODULE_SIG_SHA256).
#
# Valid values: sha512,sha384,sha256,sha224,sha1
#
# Default if unset: sha512

# @ECLASS_VARIABLE: MODULES_SIGN_KEY
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=modules-sign.  Can be set to the path of the private
# key in PEM format to use, or a PKCS#11 URI (CONFIG_MODULE_SIG_KEY).
#
# If path is relative (e.g. "certs/name.pem"), it is assumed to be
# relative to the kernel build directory being used.
#
# If the key requires a passphrase or PIN, the used kernel sign-file
# utility recognizes the KBUILD_SIGN_PIN environment variable.  Be
# warned that the package manager may store this value in binary
# packages, database files, temporary files, and possibly logs.  This
# eclass unsets the variable after use to mitigate the issue (notably
# for shared binary packages), but use this with care.
#
# Default if unset: certs/signing_key.pem

if [[ ${KERNEL_IUSE_MODULES_SIGN} ]]; then
	IUSE+=" modules-sign"
	REQUIRED_USE="secureboot? ( modules-sign )"
fi

# @FUNCTION: kernel-build_pkg_setup
# @DESCRIPTION:
# Call python-any-r1 and secureboot pkg_setup
kernel-build_pkg_setup() {
	python-any-r1_pkg_setup
	if [[ ${KERNEL_IUSE_MODULES_SIGN} ]]; then
		secureboot_pkg_setup
	fi
}

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
		STRIP="$(tc-getSTRIP)"
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
	if use arm || use arm64 || use riscv; then
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
	if use arm || use arm64 || use riscv; then
		targets+=( dtbs_install )
	fi

	# Use the kernel build system to strip, this ensures the modules
	# are stripped *before* they are signed or compressed.
	local strip_args
	if use strip; then
		strip_args="--strip-unneeded"
	fi
	# Modules were already stripped by the kernel build system
	dostrip -x /lib/modules

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_MOD_PATH="${ED}" INSTALL_MOD_STRIP="${strip_args}" \
		INSTALL_PATH="${ED}/boot" "${targets[@]}"

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

	# If a key was generated, copy it so external modules can be signed
	local suffix
	for suffix in pem x509; do
		if [[ -f "build/certs/signing_key.${suffix}" ]]; then
			cp -p "build/certs/signing_key.${suffix}" "${ED}${kernel_dir}/certs" || die
		fi
	done

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

	# unset to at least be out of the environment file in, e.g. shared binpkgs
	unset KBUILD_SIGN_PIN

	save_config build/.config
}

# @FUNCTION: kernel-build_pkg_postinst
# @DESCRIPTION:
# Combine postinst from kernel-install and savedconfig eclasses.
kernel-build_pkg_postinst() {
	kernel-install_pkg_postinst
	savedconfig_pkg_postinst

	if [[ ${KERNEL_IUSE_MODULES_SIGN} ]]; then
		if use modules-sign && [[ -z ${MODULES_SIGN_KEY} ]]; then
			ewarn
			ewarn "MODULES_SIGN_KEY was not set, this means the kernel build system"
			ewarn "automatically generated the signing key. This key was installed"
			ewarn "in ${EROOT}/usr/src/linux-${PV}${KV_LOCALVERSION}/certs"
			ewarn "and will also be included in any binary packages."
			ewarn "Please take appropriate action to protect the key!"
			ewarn
			ewarn "Recompiling this package causes a new key to be generated. As"
			ewarn "a result any external kernel modules will need to be resigned."
			ewarn "Use emerge @module-rebuild, or manually sign the modules as"
			ewarn "described on the wiki [1]"
			ewarn
			ewarn "Consider using the MODULES_SIGN_KEY variable to use an external key."
			ewarn
			ewarn "[1]: https://wiki.gentoo.org/wiki/Signed_kernel_module_support"
		fi
	fi
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

	local merge_configs=( "${@}" )

	if [[ ${KERNEL_IUSE_MODULES_SIGN} ]]; then
		if use modules-sign; then
			: "${MODULES_SIGN_HASH:=sha512}"
			cat <<-EOF > "${WORKDIR}/modules-sign.config" || die
				## Enable module signing
				CONFIG_MODULE_SIG=y
				CONFIG_MODULE_SIG_ALL=y
				CONFIG_MODULE_SIG_FORCE=y
				CONFIG_MODULE_SIG_${MODULES_SIGN_HASH^^}=y
			EOF
			if [[ ${MODULES_SIGN_KEY} == pkcs11:* || -e ${MODULES_SIGN_KEY} ]]; then
				echo "CONFIG_MODULE_SIG_KEY=\"${MODULES_SIGN_KEY}\"" \
					>> "${WORKDIR}/modules-sign.config"
			elif [[ -n ${MODULES_SIGN_KEY} ]]; then
				die "MODULES_SIGN_KEY=${MODULES_SIGN_KEY} not found!"
			fi
			merge_configs+=( "${WORKDIR}/modules-sign.config" )
		fi
	fi

	if [[ ${#user_configs[@]} -gt 0 ]]; then
		elog "User config files are being applied:"
		local x
		for x in "${user_configs[@]}"; do
			elog "- ${x}"
		done
		merge_configs+=( "${user_configs[@]}" )
	fi

	./scripts/kconfig/merge_config.sh -m -r \
		.config "${merge_configs[@]}"  || die
}

fi

EXPORT_FUNCTIONS pkg_setup src_configure src_compile src_test src_install pkg_postinst
