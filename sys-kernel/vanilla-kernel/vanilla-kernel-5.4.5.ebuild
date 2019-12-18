# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mount-boot savedconfig toolchain-funcs

MY_P=linux-${PV}
CONFIG_VER=5.4.4.arch1-1
CONFIG_HASH=f101331956bb37080dce191ca789a5c44fac9e69

DESCRIPTION="Linux kernel built from vanilla upstream sources"
HOMEPAGE="https://www.kernel.org/"
SRC_URI="https://cdn.kernel.org/pub/linux/kernel/v5.x/${MY_P}.tar.xz
	https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?h=packages/linux&id=${CONFIG_HASH}
		-> linux-${CONFIG_VER}.config"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
SLOT="${PV}"
KEYWORDS="~amd64"
IUSE="+initramfs"

# install-DEPEND actually
# note: we need installkernel with initramfs support!
RDEPEND="
	|| (
		sys-kernel/installkernel-gentoo
		sys-kernel/installkernel-systemd-boot
	)
	initramfs? ( sys-kernel/dracut )"

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

	cp "${DISTDIR}"/linux-${CONFIG_VER}.config .config || die
	# while Arch config is cool, we don't want gcc plugins as they
	# break distcc
	sed -i -e '/GCC_PLUGIN/d' .config || die
	# module compression prevents us from stripping them post-inst
	sed -i -e '/MODULE_COMPRESS/d' .config || die
	# shove our theft under the carpet!
	sed -i -e '/HOSTNAME/s:archlinux:gentoo:' .config || die
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
	:
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

		local fail=

		if use initramfs; then
			ebegin "Building initramfs via dracut"
			# putting it alongside kernel image as 'initrd' makes
			# kernel-install happier
			dracut --force "${EROOT}/usr/src/linux-${PV}/initrd" "${PV}"
			eend || die "Building initramfs failed"
		fi

		ebegin "Installing the kernel via installkernel"
		# note: .config is taken relatively to System.map;
		# initrd relatively to bzImage
		installkernel "${PV}" \
			"${EROOT}/usr/src/linux-${PV}/bzImage" \
			"${EROOT}/usr/src/linux-${PV}/System.map"
		eend || fail=1

		[[ ${fail} ]] && die "Installing the kernel failed"

		# TODO: update /usr/src/linux symlink?
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
