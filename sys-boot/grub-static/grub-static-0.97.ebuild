# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit mount-boot

DESCRIPTION="Static GNU GRUB boot loader"

HOMEPAGE="https://www.gnu.org/software/grub/"
SRC_URI="mirror://gentoo/grub-static-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* amd64 ~x86"
IUSE=""
DEPEND="!<sys-boot/grub-2"
RDEPEND="${DEPEND}"

src_install() {
	cp -a "${WORKDIR}"/* "${D}"/
}

#
# Everything below is directly copied from the grub ebuild
# please try to keep it in sync
#

setup_boot_dir() {
	local dir="${1}"

	[[ ! -e "${dir}" ]] && die "${dir} does not exist!"
	[[ ! -e "${dir}"/grub ]] && mkdir "${dir}/grub"

	# change menu.lst to grub.conf
	if [[ ! -e "${dir}"/grub/grub.conf ]] && [[ -e "${dir}"/grub/menu.lst ]] ; then
		mv -f "${dir}"/grub/menu.lst "${dir}"/grub/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi

	if [[ ! -e "${dir}"/grub/menu.lst ]]; then
	einfo "Linking from new grub.conf name to menu.lst"
		ln -snf grub.conf "${dir}"/grub/menu.lst
	fi

	[[ -e "${dir}"/grub/stage2 ]] && mv "${dir}"/grub/stage2{,.old}

	einfo "Copying files from /lib/grub and /usr/lib/grub to ${dir}"
	for x in /lib*/grub/*/* /usr/lib*/grub/*/* ; do
		[[ -f "${x}" ]] && cp -p "${x}" "${dir}"/grub/
	done

	if [[ -e "${dir}"/grub/grub.conf ]] ; then
		egrep \
			-v '^[[:space:]]*(#|$|default|fallback|initrd|password|splashimage|timeout|title)' \
			"${dir}"/grub/grub.conf | \
		/sbin/grub --batch \
			--device-map="${dir}"/grub/device.map \
			> /dev/null
	fi
}

pkg_postinst() {
	[[ "${ROOT}" != "/" ]] && return 0
	[[ -n ${DONT_MOUNT_BOOT} ]] && return 0
	setup_boot_dir /boot
	einfo "To install grub files to another device (like a usb stick), just run:"
	einfo "   emerge --config =${PF}"
}

pkg_config() {
	local dir
	einfo "Enter the directory where you want to setup grub:"
	read dir
	setup_boot_dir "${dir}"
}
