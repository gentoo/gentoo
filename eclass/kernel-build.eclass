# Copyright 2020-2026 Gentoo Authors
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

# @ECLASS_VARIABLE: KV_FULL
# @DEFAULT_UNSET
# @DESCRIPTION:
# A string containing the full kernel release version, e.g.
# '6.9.6-gentoo-dist'. This is used to ensure consistency between the
# kernel's release version and Gentoo's tooling. This is set by
# kernel-build_src_configure() once we have a kernel.release file.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_KERNEL_BUILD_ECLASS} ]]; then
_KERNEL_BUILD_ECLASS=1

PYTHON_COMPAT=( python3_{11..14} )

inherit branding multiprocessing python-any-r1 savedconfig secureboot
inherit toolchain-funcs kernel-install

BDEPEND="
	${PYTHON_DEPS}
	app-alternatives/cpio
	app-alternatives/bc
	app-arch/tar
	dev-lang/perl
	sys-devel/bison
	sys-devel/flex
	virtual/libelf
	arm? ( sys-apps/dtc )
	arm64? ( sys-apps/dtc )
	modules-sign? ( dev-libs/openssl )
	riscv? ( sys-apps/dtc )
"

IUSE="+strip modules-sign"
REQUIRED_USE="secureboot? ( modules-sign )"

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

# @ECLASS_VARIABLE: MODULES_SIGN_CERT
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Used with USE=modules-sign.  Can be set to the path of the public
# key in PEM format to use. Must be specified if MODULES_SIGN_KEY
# is set to a path of a file that only contains the private key.

# @ECLASS_VARIABLE: KERNEL_GENERIC_UKI_CMDLINE
# @USER_VARIABLE
# @DESCRIPTION:
# If KERNEL_IUSE_GENERIC_UKI is set, and this variable is not
# empty, then the contents are used as the first kernel cmdline
# option of the multi-profile generic UKI. Supplementing the four
# standard options of:
# - quiet
# - quiet splash
# - quiet lockdown=integrity
# - quiet splash lockdown=integrity
# - emergency
# - rescue

if [[ ${KERNEL_IUSE_GENERIC_UKI} ]]; then
	BDEPEND+="
		generic-uki? ( ${!INITRD_PACKAGES[@]} )
	"
fi

# @FUNCTION: kernel-build_pkg_setup
# @DESCRIPTION:
# Call python-any-r1 and secureboot pkg_setup
kernel-build_pkg_setup() {
	python-any-r1_pkg_setup
	if [[ ${MERGE_TYPE} != binary ]]; then
		# inherits linux-info to check config values for keys
		# ensure KV_FULL will not be set globally, that breaks configure
		local KV_FULL
		secureboot_pkg_setup

		if use modules-sign && [[ -n ${MODULES_SIGN_KEY} ]]; then
			# Sanity check: fail early if key/cert in DER format or does not exist
			local openssl_args=(
				-noout -nocert
			)
			if [[ -n ${MODULES_SIGN_CERT} ]]; then
				openssl_args+=( -inform PEM -in "${MODULES_SIGN_CERT}" )
			else
				# If no cert specified, we assume the pem key also contains the cert
				openssl_args+=( -inform PEM -in "${MODULES_SIGN_KEY}" )
			fi
			if [[ ${MODULES_SIGN_KEY} == pkcs11:* ]]; then
				openssl_args+=( -engine pkcs11 -keyform ENGINE -key "${MODULES_SIGN_KEY}" )
			else
				openssl_args+=( -keyform PEM -key "${MODULES_SIGN_KEY}" )
			fi

			openssl x509 "${openssl_args[@]}" ||
				die "Kernel module signing certificate or key not found or not PEM format."

			if [[ ${MODULES_SIGN_KEY} != pkcs11:* ]]; then
				if [[ -n ${MODULES_SIGN_CERT} && ${MODULES_SIGN_CERT} != ${MODULES_SIGN_KEY} ]]; then
					MODULES_SIGN_KEY_CONTENTS="$(cat "${MODULES_SIGN_CERT}" "${MODULES_SIGN_KEY}" || die)"
				else
					MODULES_SIGN_KEY_CONTENTS="$(< "${MODULES_SIGN_KEY}")"
				fi
			fi
		fi
	fi
}

# @FUNCTION: kernel-build_src_configure
# @DESCRIPTION:
# Prepare the toolchain for building the kernel, get the .config file,
# and get build tree configured for modprep.
kernel-build_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

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
	local HOSTLD="$(tc-getBUILD_LD)"
	if type -P "${HOSTLD}.bfd" &>/dev/null; then
		HOSTLD+=.bfd
	fi
	local LD="$(tc-getLD)"
	if type -P "${LD}.bfd" &>/dev/null; then
		LD+=.bfd
	fi

	tc-export_build_env
	MAKEARGS=(
		V=1
		WERROR=0

		HOSTCC="$(tc-getBUILD_CC)"
		HOSTCXX="$(tc-getBUILD_CXX)"
		HOSTLD="${HOSTLD}"
		HOSTAR="$(tc-getBUILD_AR)"
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
		READELF="$(tc-getREADELF)"
		TAR=gtar

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

	[[ -f .config ]] || die "Ebuild error: No .config, kernel-build_merge_configs was not called."

	if [[ -z "${KV_LOCALVERSION}" ]]; then
		KV_LOCALVERSION=$(sed -n -e 's#^CONFIG_LOCALVERSION="\(.*\)"$#\1#p' \
			.config)
	fi

	# If this is set by USE=secureboot or user config this will have an effect
	# on the name of the output image. Set this variable to track this setting.
	if grep -q "CONFIG_EFI_ZBOOT=y" .config; then
		KERNEL_EFI_ZBOOT=1
	elif { use arm64 || use riscv || use loong ;} &&
		[[ ${KERNEL_IUSE_GENERIC_UKI} ]] && use generic-uki; then
			die "USE=generic-uki requires enabling CONFIG_EFI_ZBOOT"
	fi

	mkdir -p "${WORKDIR}"/modprep || die
	mv .config "${WORKDIR}"/modprep/ || die
	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" olddefconfig

	local k_release=$(emake -s O="${WORKDIR}"/modprep "${MAKEARGS[@]}" kernelrelease)
	if [[ -z ${KV_FULL} ]]; then
		KV_FULL=${k_release}
	fi

	# Make sure we are about to build the correct kernel
	if [[ ${PV} != *9999 ]]; then
		local expected_ver=$(dist-kernel_PV_to_KV "${PV}")

		if [[ ${KV_FULL} != ${k_release} ]]; then
			eerror "KV_FULL mismatch!"
			eerror "KV_FULL:  ${KV_FULL}"
			eerror "Expected: ${k_release}"
			die "KV_FULL mismatch: got ${KV_FULL}, expected ${k_release}"
		fi

		if [[ ${KV_FULL} != ${expected_ver}* ]]; then
			eerror "Kernel version does not match PV!"
			eerror "Source version: ${KV_FULL}"
			eerror "Expected (PV*): ${expected_ver}*"
			eerror "Please ensure you are applying the correct patchset."
			die "Kernel version mismatch: got ${KV_FULL}, expected ${expected_ver}*"
		fi
	fi

	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" modules_prepare
	cp -pR "${WORKDIR}"/modprep "${WORKDIR}"/build || die
}

# @FUNCTION: kernel-build_src_compile
# @DESCRIPTION:
# Compile the kernel sources.
kernel-build_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	local targets=( all )

	if grep -q "CONFIG_CTF=y" "${WORKDIR}/modprep/.config"; then
		targets+=( ctf )
	fi

	local target
	for target in "${targets[@]}" ; do
		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" "${target}"
	done
}

# @FUNCTION: kernel-build_src_test
# @DESCRIPTION:
# Test the built kernel via qemu.  This just wraps the logic
# from kernel-install.eclass with the correct paths.
kernel-build_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	local targets=( modules_install )

	if grep -q "CONFIG_CTF=y" "${WORKDIR}/modprep/.config"; then
		targets+=( ctf_install )
	fi

	# Use the kernel build system to strip, this ensures the modules
	# are stripped *before* they are signed or compressed.
	local strip_args
	if use strip; then
		strip_args="--strip-unneeded"
	fi

	local target
	for target in "${targets[@]}" ; do
		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
			INSTALL_MOD_PATH="${T}" INSTALL_MOD_STRIP="${strip_args}" \
			"${target}"
	done

	kernel-install_test "${KV_FULL}" \
		"${WORKDIR}/build/$(dist-kernel_get_image_path)" \
		"${T}/lib/modules/${KV_FULL}"
}

# @FUNCTION: kernel-build_src_install
# @DESCRIPTION:
# Install the built kernel along with subset of sources
# into /usr/src/linux-${KV_FULL}.  Install the modules.  Save the config.
kernel-build_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	# do not use 'make install' as it behaves differently based
	# on what kind of installkernel is installed
	local targets=( modules_install )
	# on arm or arm64 you also need dtb
	if use arm || use arm64 || use riscv; then
		targets+=( dtbs_install )
	fi

	if grep -q "CONFIG_CTF=y" "${WORKDIR}/modprep/.config"; then
		targets+=( ctf_install )
	fi

	# Use the kernel build system to strip, this ensures the modules
	# are stripped *before* they are signed or compressed.
	local strip_args
	if use strip; then
		strip_args="--strip-unneeded"
	fi
	# Modules were already stripped by the kernel build system
	dostrip -x /lib/modules

	local compress=()
	if [[ ${KERNEL_IUSE_GENERIC_UKI} ]] && ! use modules-compress; then
		compress+=(
			# Workaround for <6.12, does not have CONFIG_MODULE_COMPRESS_ALL
			suffix-y=
		)
	fi

	local target
	for target in "${targets[@]}" ; do
		emake O="${WORKDIR}"/build "${MAKEARGS[@]}" INSTALL_PATH="${ED}/boot" \
			INSTALL_MOD_PATH="${ED}" INSTALL_MOD_STRIP="${strip_args}" \
			INSTALL_DTBS_PATH="${ED}/lib/modules/${KV_FULL}/dtb" \
			"${compress[@]}" "${target}"
	done

	# note: we're using mv rather than doins to save space and time
	# install main and arch-specific headers first, and scripts
	local kern_arch=$(tc-arch-kernel)
	local kernel_dir=/usr/src/linux-${KV_FULL}

	if use sparc ; then
		# We don't want tc-arch-kernel's sparc64, even though we do
		# need to pass ARCH=sparc64 to the build system. It's a quasi-alias
		# in Kbuild.
		kern_arch=sparc
	fi

	dodir "${kernel_dir}/arch/${kern_arch}"
	mv certs include scripts "${ED}${kernel_dir}/" || die
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
	# If CONFIG_MODULES=y, then kernel.release will be found in modprep as well, but not
	# in case of CONFIG_MODULES is not set.
	# The one in build is exactly the same as the one in modprep, but the one in build
	# always exists, so it can just be copied unconditionally.
	cp "${WORKDIR}/build/include/config/kernel.release" \
		"${ED}${kernel_dir}/include/config/" || die

	# install the kernel and files needed for module builds
	insinto "${kernel_dir}"
	doins build/System.map
	# build/Module.symvers does not exist if CONFIG_MODULES is not set.
	[[ -f build/Module.symvers ]] && doins build/Module.symvers
	local image_path=$(dist-kernel_get_image_path)
	local image=${ED}${kernel_dir}/${image_path}
	cp -p "build/${image_path}" "${image}" || die

	# Copy built key/certificate files
	cp -p build/certs/* "${ED}${kernel_dir}/certs/" || die
	# If a key was generated, exclude it from the binpkg
	local generated_key=${ED}${kernel_dir}/certs/signing_key.pem
	if [[ -r ${generated_key} ]]; then
		mv "${generated_key}" "${T}/signing_key.pem" || die
	fi

	# building modules fails with 'vmlinux has no symtab?' if stripped
	use ppc64 && dostrip -x "${kernel_dir}/${image_path}"

	# Install vmlinux with debuginfo when requested
	if use debug; then
		if [[ "${image_path}" != "vmlinux" ]]; then
			mv "build/vmlinux" "${ED}${kernel_dir}/vmlinux" || die
		fi
		dostrip -x "${kernel_dir}/vmlinux"
		dostrip -x "${kernel_dir}/vmlinux.ctfa"
	fi

	# strip empty directories
	find "${D}" -type d -empty -exec rmdir {} + || die

	# warn when trying to "make" a dist-kernel
	cat <<-EOF >> "${ED}${kernel_dir}/Makefile" || die

		_GENTOO_IS_USER_SHELL:=\$(shell [ -t 0 ] && echo 1)
		ifdef _GENTOO_IS_USER_SHELL
		\$(warning !!!! WARNING !!!!)
		\$(warning This kernel was configured and installed by the package manager.)
		\$(warning "make" should not be run manually here.)
		\$(warning See also: https://wiki.gentoo.org/wiki/Project:Distribution_Kernel)
		\$(warning See also: https://wiki.gentoo.org/wiki/Kernel/Configuration)
		\$(warning !!!! WARNING !!!!)
		endif
	EOF
	# add a dist-kernel identifier file
	echo "${CATEGORY}/${PF}:${SLOT}" > "${ED}${kernel_dir}/dist-kernel" || die

	# fix source tree and build dir symlinks
	dosym "../../../${kernel_dir}" "/lib/modules/${KV_FULL}/build"
	dosym "../../../${kernel_dir}" "/lib/modules/${KV_FULL}/source"
	dosym "../../../${kernel_dir}/.config" "/lib/modules/${KV_FULL}/config"
	dosym "../../../${kernel_dir}/System.map" "/lib/modules/${KV_FULL}/System.map"
	if [[ "${image_path}" == *vmlinux* ]]; then
		dosym "../../../${kernel_dir}/${image_path}" "/lib/modules/${KV_FULL}/vmlinux"
	else
		dosym "../../../${kernel_dir}/${image_path}" "/lib/modules/${KV_FULL}/vmlinuz"
	fi

	if [[ ${image} == *.gz ]]; then
		# Backwards compatibility with pre-zboot images
		gunzip "${image}" || die
		secureboot_sign_efi_file "${image%.gz}"
		# Use same gzip options as the kernel Makefile
		gzip -n -f -9 "${image%.gz}" || die
	else
		secureboot_sign_efi_file "${image}"
	fi

	if [[ ${KERNEL_IUSE_GENERIC_UKI} ]]; then
		if use generic-uki; then
			# NB: if you pass a path that does not exist or is not a regular
			# file/directory, dracut will silently ignore it and use the default
			# https://github.com/dracutdevs/dracut/issues/1136
			> "${T}"/empty-file || die
			mkdir -p "${T}"/empty-directory || die

			local dracut_modules=(
				base bash btrfs cifs crypt crypt-gpg crypt-loop dbus dbus-daemon
				dm dmraid dracut-systemd drm fido2 i18n fs-lib kernel-modules
				kernel-network-modules kernel-modules-extra lunmask lvm nbd
				mdraid modsign network network-manager nfs nvdimm nvmf pcsc
				pkcs11 plymouth qemu qemu-net resume rngd rootfs-block shutdown
				systemd systemd-ac-power systemd-ask-password systemd-cryptsetup
				systemd-emergency systemd-initrd systemd-integritysetup
				systemd-pcrphase systemd-sysusers systemd-udevd
				systemd-veritysetup terminfo tpm2-tss udev-rules uefi-lib
				usrmount virtiofs
			)

			local dracut_args=(
				--conf "${T}/empty-file"
				--confdir "${T}/empty-directory"
				--kernel-image "${image}"
				--kmoddir "${ED}/lib/modules/${KV_FULL}"
				--kver "${KV_FULL}"
				--verbose
				--compress="xz -9e --check=crc32"
				--no-hostonly
				--no-hostonly-cmdline
				--no-hostonly-i18n
				--no-machineid
				--nostrip
				--no-uefi
				--early-microcode
				--reproducible
				--ro-mnt
				--modules "${dracut_modules[*]}"
				# Pulls in huge firmware files
				--omit-drivers "amdgpu i915 nfp nouveau nvidia xe"
			)

			# Tries to update ld cache
			addpredict /etc/ld.so.cache~
			dracut "${dracut_args[@]}" "${image%/*}/initrd" ||
				die "Failed to generate initramfs"

			# Note, we cannot use an associative array here because those are
			# not ordered.
			local profiles=()
			local cmdlines=()

			# If defined, make the user entry the first and default
			if [[ -n ${KERNEL_GENERIC_UKI_CMDLINE} ]]; then
				profiles+=(
					$'TITLE=User specified at build time\nID=user'
				)
				cmdlines+=( "${KERNEL_GENERIC_UKI_CMDLINE}" )
			fi

			profiles+=(
				$'TITLE=Default\nID=default'
				$'TITLE=Default with splash\nID=splash'
				$'TITLE=Default with lockdown\nID=lockdown'
				$'TITLE=Default with splash and lockdown\nID=splash-lockdown'
				$'TITLE=Emergency\nID=emergency'
				$'TITLE=Rescue\nID=rescue'
			)

			cmdlines+=(
				"quiet"
				"quiet splash"
				"quiet lockdown=integrity"
				"quiet splash lockdown=integrity"
				"emergency"
				"rescue"
			)

			local os_release=(
				${BRANDING_OS_NAME+"NAME='${BRANDING_OS_NAME}'"}
				${BRANDING_OS_ID+"ID='${BRANDING_OS_ID}'"}
				${BRANDING_OS_ID_LIKE+"ID_LIKE='${BRANDING_OS_ID_LIKE}'"}
				${BRANDING_OS_HOME_URL+"HOME_URL='${BRANDING_OS_HOME_URL}'"}
				${BRANDING_OS_SUPPORT_URL+"SUPPORT_URL='${BRANDING_OS_SUPPORT_URL}'"}
				${BRANDING_OS_BUG_REPORT_URL+"BUG_REPORT_URL='${BRANDING_OS_BUG_REPORT_URL}'"}
				${BRANDING_OS_VERSION+"VERSION='${BRANDING_OS_VERSION}'"}
				${BRANDING_OS_VERSION_ID+"VERSION_ID='${BRANDING_OS_VERSION_ID}'"}
				${BRANDING_OS_PRETTY_NAME+"PRETTY_NAME='${BRANDING_OS_PRETTY_NAME}'"}
			)

			local ukify_args=(
				--linux="${image}"
				--initrd="${image%/*}/initrd"
				--uname="${KV_FULL}"
				--output="${image%/*}/uki.efi"
				--profile="${profiles[0]}"
				--cmdline="${cmdlines[0]}"
				--os-release="$(printf '%s\n' "${os_release[@]}")"
			) # 0th profile is default

			# Additional profiles have to be added with --join-profile
			local i
			for (( i=1; i<"${#profiles[@]}"; i++ )); do
				ukify build \
					--profile="${profiles[i]}" \
					--cmdline="${cmdlines[i]}" \
					--output="${T}/profile${i}.efi" ||
						die "Failed to create profile ${i}"

				ukify_args+=( --join-profile="${T}/profile${i}.efi" )
			done

			if use secureboot; then
				# The PCR public key option should contain *only* the
				# public key, not the full certificate containing the
				# public key. Bug #960276
				openssl x509 \
					-in "${SECUREBOOT_SIGN_CERT}" -inform PEM \
					-noout -pubkey > "${T}/pcrpkey.pem" ||
						die "Failed to extract public key"
				ukify_args+=(
					--secureboot-private-key="${SECUREBOOT_SIGN_KEY}"
					--secureboot-certificate="${SECUREBOOT_SIGN_CERT}"
					--pcrpkey="${T}/pcrpkey.pem"
					--measure
				)
				if [[ ${SECUREBOOT_SIGN_KEY} == pkcs11:* ]]; then
					ukify_args+=(
						--signing-engine="pkcs11"
						--pcr-private-key="${SECUREBOOT_SIGN_KEY}"
						--pcr-public-key="${T}/pcrpkey.pem"
						--phases="enter-initrd"
						--pcr-private-key="${SECUREBOOT_SIGN_KEY}"
						--pcr-public-key="${T}/pcrpkey.pem"
						--phases="enter-initrd:leave-initrd enter-initrd:leave-initrd:sysinit enter-initrd:leave-initrd:sysinit:ready"
					)
				else
					ukify_args+=(
						--pcr-private-key="${SECUREBOOT_SIGN_KEY}"
						--pcr-public-key="${T}/pcrpkey.pem"
						--phases="enter-initrd"
						--pcr-private-key="${SECUREBOOT_SIGN_KEY}"
						--pcr-public-key="${T}/pcrpkey.pem"
						--phases="enter-initrd:leave-initrd enter-initrd:leave-initrd:sysinit enter-initrd:leave-initrd:sysinit:ready"
					)
				fi
			fi

			ukify build "${ukify_args[@]}" || die "Failed to generate UKI"

			# Overwrite unnecessary image types to save space
			> "${image}" || die
		else
			# Placeholders to ensure we own these files
			> "${image%/*}/uki.efi" || die
		fi
		> "${image%/*}/initrd" || die
	fi

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

	if use modules-sign && [[ -z ${MODULES_SIGN_KEY} ]]; then
		ewarn
		ewarn "MODULES_SIGN_KEY was not set, this means the kernel build system"
		ewarn "automatically generated the signing key. This key was installed"
		ewarn "in ${EROOT}/usr/src/linux-${KV_FULL}/certs"
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
}

# @FUNCTION: kernel-build_merge_configs
# @USAGE: [distro.config...]
# @DESCRIPTION:
# Merge kernel config files.  The following is merged onto the '.config'
# file in the current directory, in order:
#
# 1. Config files specified as arguments.
# 2. Default module signing and compression configuration
#    (if applicable).
# 3. Config saved via USE=savedconfig (if applicable).
# 4. Module signing key specified via MODULES_SIGN_KEY* variables.
# 5. User-supplied configs from ${BROOT}/etc/kernel/config.d/*.config.
#
# This function must be called by the ebuild in the src_prepare phase.
kernel-build_merge_configs() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -f .config ]] ||
		die "${FUNCNAME}: No .config, please copy default config into .config"
	has .config "${@}" &&
		die "${FUNCNAME}: do not specify .config as parameter"

	local shopt_save=$(shopt -p nullglob)
	shopt -s nullglob
	local user_configs=( "${BROOT}"/etc/kernel/config.d/*.config )
	eval "${shopt_save}"

	local merge_configs=( "${@}" )

	if use modules-sign; then
		: "${MODULES_SIGN_HASH:=sha512}"
		cat <<-EOF > "${WORKDIR}/modules-sign.config" || die
			## Enable module signing
			CONFIG_MODULE_SIG=y
			CONFIG_MODULE_SIG_ALL=y
			CONFIG_MODULE_SIG_FORCE=y
			CONFIG_MODULE_SIG_${MODULES_SIGN_HASH^^}=y
		EOF
		merge_configs+=( "${WORKDIR}/modules-sign.config" )
	fi

	# Only semi-related but let's use that to avoid changing stable ebuilds.
	if [[ ${KERNEL_IUSE_GENERIC_UKI} ]]; then
		# NB: we enable support for compressed modules even with
		# USE=-modules-compress, in order to support both uncompressed and
		# compressed modules in prebuilt kernels.
		cat <<-EOF > "${WORKDIR}/module-compress.config" || die
			CONFIG_MODULE_COMPRESS=y
			CONFIG_MODULE_COMPRESS_XZ=y
		EOF
		# CONFIG_MODULE_COMPRESS_ALL is supported only by >=6.12, for older
		# versions we accomplish the same by overriding suffix-y=
		if use modules-compress; then
			echo "CONFIG_MODULE_COMPRESS_ALL=y" \
				>> "${WORKDIR}/module-compress.config" || die
		else
			echo "# CONFIG_MODULE_COMPRESS_ALL is not set" \
				>> "${WORKDIR}/module-compress.config" || die
		fi
		merge_configs+=( "${WORKDIR}/module-compress.config" )
	fi

	restore_config "${WORKDIR}/savedconfig.config"
	if [[ -f ${WORKDIR}/savedconfig.config ]]; then
		merge_configs+=( "${WORKDIR}/savedconfig.config" )
	fi

	if use modules-sign; then
		local modules_sign_key=${MODULES_SIGN_KEY}
		if [[ -n ${MODULES_SIGN_KEY_CONTENTS} ]]; then
			modules_sign_key="${T}/kernel_key.pem"
			(umask 066 && touch "${modules_sign_key}" || die)
			echo "${MODULES_SIGN_KEY_CONTENTS}" > "${modules_sign_key}" || die
			unset MODULES_SIGN_KEY_CONTENTS
		fi
		if [[ ${modules_sign_key} == pkcs11:* || -r ${modules_sign_key} ]]; then
			echo "CONFIG_MODULE_SIG_KEY=\"${modules_sign_key}\"" \
				>> "${WORKDIR}/modules-sign-key.config"
			merge_configs+=( "${WORKDIR}/modules-sign-key.config" )
		elif [[ -n ${modules_sign_key} ]]; then
			die "MODULES_SIGN_KEY=${modules_sign_key} not found or not readable!"
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
