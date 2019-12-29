# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot savedconfig toolchain-funcs

MY_P=linux-${PV}
TCL_VER=10.1
AMD64_CONFIG_VER=5.4.4.arch1-1
AMD64_CONFIG_HASH=f101331956bb37080dce191ca789a5c44fac9e69
I686_CONFIG_VER=5.4.3-arch1
I686_CONFIG_HASH=076a52d43a08c4b3a3eacd1f2f9a855fb3b62f42

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v5.x/${MY_P}.tar.xz
	amd64? (
		https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux&id=${AMD64_CONFIG_HASH}
			-> linux-${AMD64_CONFIG_VER}.amd64.config
		test? (
			https://dev.gentoo.org/~mgorny/dist/tinycorelinux-${TCL_VER}-amd64.qcow2
		)
	)
	x86? (
		https://git.archlinux32.org/packages/plain/core/linux/config.i686?id=${I686_CONFIG_HASH}
			-> linux-${I686_CONFIG_VER}.i686.config
		test? (
			https://dev.gentoo.org/~mgorny/dist/tinycorelinux-${TCL_VER}-x86.qcow2
		)
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="+initramfs test"
RESTRICT="!test? ( test ) test? ( userpriv )"

# install-DEPEND actually
# note: we need installkernel with initramfs support!
RDEPEND="
	|| (
		sys-kernel/installkernel-gentoo
		sys-kernel/installkernel-systemd-boot
	)
	initramfs? ( >=sys-kernel/dracut-049-r2 )"
BDEPEND="
	sys-devel/bc
	virtual/libelf
	test? (
		dev-tcltk/expect
		sys-kernel/dracut
		amd64? ( app-emulation/qemu[qemu_softmmu_targets_x86_64] )
		x86? ( app-emulation/qemu[qemu_softmmu_targets_i386] )
	)"

pkg_pretend() {
	mount-boot_pkg_pretend

	ewarn "This is an experimental package.  The built kernel and/or initramfs"
	ewarn "may not work at all or fail with your bootloader configuration.  Please"
	ewarn "make sure to keep a backup kernel available before testing it."
}

src_configure() {
	# force ld.bfd if we can find it easily
	local LD="$(tc-getLD)"
	if type -P "${LD}.bfd" &>/dev/null; then
		LD+=.bfd
	fi

	MAKEARGS=(
		V=1

		HOSTCC="$(tc-getCC)"
		HOSTCXX="$(tc-getCXX)"
		HOSTCFLAGS="${CFLAGS}"
		HOSTLDFLAGS="${LDFLAGS}"

		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		LD="${LD}"
		AR="$(tc-getAR)"
		NM="$(tc-getNM)"
		STRIP=":"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"

		# we need to pass it to override colliding Gentoo envvar
		ARCH=x86
	)

	case ${ARCH} in
		amd64)
			cp "${DISTDIR}"/linux-${AMD64_CONFIG_VER}.amd64.config .config || die
			;;
		x86)
			cp "${DISTDIR}"/linux-${I686_CONFIG_VER}.i686.config .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac

	# while Arch config is cool, we don't want gcc plugins as they
	# break distcc
	sed -i -e '/GCC_PLUGIN/d' .config || die
	# module compression prevents us from stripping them post-inst
	sed -i -e '/MODULE_COMPRESS/d' .config || die
	# shove our theft under the carpet!
	sed -i -e '/HOSTNAME/s:archlinux:gentoo:' .config || die
	# hey, we do support x32
	sed -i -e '/CONFIG_X86_X32/s:.*:CONFIG_X86_X32=y:' .config || die
	restore_config .config

	mkdir -p "${WORKDIR}"/modprep || die
	mv .config "${WORKDIR}"/modprep/ || die
	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" olddefconfig
	emake O="${WORKDIR}"/modprep "${MAKEARGS[@]}" modules_prepare
	cp -pR "${WORKDIR}"/modprep "${WORKDIR}"/build || die
}

src_compile() {
	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" all
}

src_test() {
	local image_arch=${ARCH}
	local kern_arch=x86
	local qemu_arch=$(usex amd64 x86_64 i386)

	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_MOD_PATH="${T}" modules_install

	dracut \
		--conf /dev/null \
		--confdir /dev/null \
		--no-hostonly \
		--kmoddir "${T}/lib/modules/${PV}" \
		"${T}/initrd" "${PV}" || die
	cp "${DISTDIR}/tinycorelinux-${TCL_VER}-${image_arch}.qcow2" \
		"${T}/fs.qcow2" || die

	cd "${T}" || die
	cat > run.sh <<-EOF || die
		#!/bin/sh
		exec qemu-system-${qemu_arch} \
			-m 256M \
			-display none \
			-no-reboot \
			-kernel '${WORKDIR}/build/arch/${kern_arch}/boot/bzImage' \
			-initrd '${T}/initrd' \
			-serial mon:stdio \
			-hda '${T}/fs.qcow2' \
			-append 'root=/dev/sda console=ttyS0,115200n8'
	EOF
	chmod +x run.sh || die
	# TODO: initramfs does not let core finish starting on some systems,
	# figure out how to make it better at that
	expect - <<-EOF || die "Booting kernel failed"
		set timeout 900
		spawn ./run.sh
		expect {
			"Kernel panic" {
				send_error "\n* Kernel panic"
				exit 1
			}
			"Entering emergency mode" {
				send_error "\n* Initramfs failed to start the system"
				exit 1
			}
			"Core 10.1" {
				send_error "\n* Booted to login"
				exit 0
			}
			timeout {
				send_error "\n* Kernel boot timed out"
				exit 2
			}
		}
	EOF
}

src_install() {
	# do not use 'make install' as it behaves differently based
	# on what kind of installkernel is installed
	emake O="${WORKDIR}"/build "${MAKEARGS[@]}" \
		INSTALL_MOD_PATH="${ED}" modules_install

	# install headers and prepared objects on top of them
	# note: we're using mv rather than doins to save space and time
	find -name '*.c' -delete || die
	rm -r Documentation || die
	dodir /usr/src
	cd "${WORKDIR}" || die
	mv "${S}" "${ED}"/usr/src/ || die
	# strip out-of-source build stuffs from modprep
	find modprep -type f '(' \
			-name Makefile -o \
			-name '*.[ao]' -o \
			'(' -name '.*' -a -not -name '.config' ')' \
		')' -delete || die
	rm modprep/source || die
	cp -pR modprep/. "${ED}/usr/src/linux-${PV}"/ || die

	# install the kernel and files needed for module builds
	cp build/{arch/x86/boot/bzImage,System.map,Module.symvers} \
		"${ED}/usr/src/linux-${PV}"/ || die

	# fix source tree and build dir symlinks
	dosym ../../../usr/src/linux-${PV} /lib/modules/${PV}/build
	dosym ../../../usr/src/linux-${PV} /lib/modules/${PV}/source

	save_config build/.config
}

pkg_preinst() {
	:
}

pkg_postinst() {
	if [[ -z ${ROOT} ]]; then
		mount-boot_pkg_preinst

		if use initramfs; then
			ebegin "Building initramfs via dracut"
			# putting it alongside kernel image as 'initrd' makes
			# kernel-install happier
			dracut --force "${EROOT}/usr/src/linux-${PV}/initrd" "${PV}"
			eend ${?} || die "Building initramfs failed"
		fi

		ebegin "Installing the kernel via installkernel"
		# note: .config is taken relatively to System.map;
		# initrd relatively to bzImage
		installkernel "${PV}" \
			"${EROOT}/usr/src/linux-${PV}/bzImage" \
			"${EROOT}/usr/src/linux-${PV}/System.map"
		eend ${?} || die "Installing the kernel failed"
	fi

	local symlink_target=$(readlink "${EROOT}"/usr/src/linux)
	local symlink_ver=${symlink_target#linux-}
	if [[ ${symlink_target} == linux-* && -z ${symlink_ver//[0-9.]/} ]]
	then
		local symlink_pkg=${CATEGORY}/${PN}-${symlink_ver}
		# if the current target is either being replaced, or still
		# installed (probably depclean candidate), update the symlink
		if has "${symlink_ver}" ${REPLACING_VERSIONS} ||
				has_version -r "~${symlink_pkg}"
		then
			ebegin "Updating /usr/src/linux symlink"
			ln -f -n -s linux-${PV} "${EROOT}"/usr/src/linux
			eend ${?}
		fi
	fi

	savedconfig_pkg_postinst
}

pkg_prerm() {
	:
}

pkg_postrm() {
	rm -f "${EROOT}/usr/src/linux-${PV}/initrd" &&
	rmdir --ignore-fail-on-non-empty "${EROOT}/usr/src/linux-${PV}"
}
