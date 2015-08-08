# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# XXX: we need to review menu.lst vs grub.conf handling.  We've been converting
#      all systems to grub.conf (and symlinking menu.lst to grub.conf), but
#      we never updated any of the source code (it still all wants menu.lst),
#      and there is no indication that upstream is making the transition.

inherit eutils mount-boot

PATCHVER="1.7" # Not used, just for tracking with main grub

DESCRIPTION="GNU GRUB Legacy boot loader (static build)"

HOMEPAGE="http://www.gnu.org/software/grub/"
SRC_URI="mirror://gentoo/${PF}.tar.bz2"
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
# Below this point, everything is also used in grub-static!
# Please keep in sync!
#

setup_boot_dir() {
	local boot_dir=$1
	local dir=${boot_dir}

	[[ ! -e ${dir} ]] && die "${dir} does not exist!"
	[[ ! -L ${dir}/boot ]] && ln -s . "${dir}/boot"
	dir="${dir}/grub"
	if [[ ! -e ${dir} ]] ; then
		mkdir "${dir}" || die "${dir} does not exist!"
	fi

	# change menu.lst to grub.conf
	if [[ ! -e ${dir}/grub.conf ]] && [[ -e ${dir}/menu.lst ]] ; then
		mv -f "${dir}"/menu.lst "${dir}"/grub.conf
		ewarn
		ewarn "*** IMPORTANT NOTE: menu.lst has been renamed to grub.conf"
		ewarn
	fi

	if [[ ! -e ${dir}/menu.lst ]]; then
		einfo "Linking from new grub.conf name to menu.lst"
		ln -snf grub.conf "${dir}"/menu.lst
	fi

	if [[ -e ${dir}/stage2 ]] ; then
		mv "${dir}"/stage2{,.old}
		ewarn "*** IMPORTANT NOTE: you must run grub and install"
		ewarn "the new version's stage1 to your MBR.  Until you do,"
		ewarn "stage1 and stage2 will still be the old version, but"
		ewarn "later stages will be the new version, which could"
		ewarn "cause problems such as an unbootable system."
		ewarn "This means you must use either grub-install or perform"
		ewarn "root/setup manually! For more help, see the handbook:"
		ewarn "http://www.gentoo.org/doc/en/handbook/handbook-${ARCH}.xml?part=1&chap=10#grub-install-auto"
		ebeep
	fi

	einfo "Copying files from /lib/grub, /usr/lib/grub and /usr/share/grub to ${dir}"
	for x in \
		"${ROOT}"/lib*/grub/*/* \
		"${ROOT}"/usr/lib*/grub/*/* \
		"${ROOT}"/usr/share/grub/* ; do
		[[ -f ${x} ]] && cp -p "${x}" "${dir}"/
	done

	if [[ ! -e ${dir}/grub.conf ]] ; then
		s="${ROOT}/usr/share/doc/${PF}/grub.conf.gentoo"
		[[ -e "${s}" ]] && cat "${s}" >${dir}/grub.conf
		[[ -e "${s}.gz" ]] && zcat "${s}.gz" >${dir}/grub.conf
		[[ -e "${s}.bz2" ]] && bzcat "${s}.bz2" >${dir}/grub.conf
	fi

	# Per bug 218599, we support grub.conf.install for users that want to run a
	# specific set of Grub setup commands rather than the default ones.
	grub_config=${dir}/grub.conf.install
	[[ -e ${grub_config} ]] || grub_config=${dir}/grub.conf
	if [[ -e ${grub_config} ]] ; then
		egrep \
			-v '^[[:space:]]*(#|$|default|fallback|initrd|password|splashimage|timeout|title)' \
			"${grub_config}" | \
		/sbin/grub --batch \
			--device-map="${dir}"/device.map \
			> /dev/null
	fi

	# the grub default commands silently piss themselves if
	# the default file does not exist ahead of time
	if [[ ! -e ${dir}/default ]] ; then
		grub-set-default --root-directory="${boot_dir}" default
	fi
	einfo "Grub has been installed to ${boot_dir} successfully."
}

pkg_postinst() {
	if [[ -n ${DONT_MOUNT_BOOT} ]]; then
		elog "WARNING: you have DONT_MOUNT_BOOT in effect, so you must apply"
		elog "the following instructions for your /boot!"
		elog "Neglecting to do so may cause your system to fail to boot!"
		elog
	else
		setup_boot_dir "${ROOT}"/boot
		# Trailing output because if this is run from pkg_postinst, it gets mixed into
		# the other output.
		einfo ""
	fi
	elog "To interactively install grub files to another device such as a USB"
	elog "stick, just run the following and specify the directory as prompted:"
	elog "   emerge --config =${PF}"
	elog "Alternately, you can export GRUB_ALT_INSTALLDIR=/path/to/use to tell"
	elog "grub where to install in a non-interactive way."

}

pkg_config() {
	local dir
	if [ ! -d "${GRUB_ALT_INSTALLDIR}" ]; then
		einfo "Enter the directory where you want to setup grub:"
		read dir
	else
		dir="${GRUB_ALT_INSTALLDIR}"
	fi
	setup_boot_dir "${dir}"
}
