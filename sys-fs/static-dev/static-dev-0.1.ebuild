# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="A skeleton, statically managed /dev"
HOMEPAGE="https://bugs.gentoo.org/107875"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

RDEPEND="sys-apps/makedev"
DEPEND="${RDEPEND}"

abort() {
	echo
	eerror "We have detected that you currently use udev or devfs or devtmpfs"
	eerror "and this ebuild cannot install to the same mount-point."
	die "Cannot install on udev/devfs tmpfs."
}

pkg_pretend() {
	if [[ ${MERGE_TYPE} == "buildonly" ]] ; then
		# User is just compiling which is fine -- all our checks are merge-time.
		return
	fi

	# We want to not clobber udev (tmpfs) or older devfs setups.
	if [[ -d ${ROOT}/dev/.udev || -c ${ROOT}/dev/.devfs ]] ; then
		abort
	fi
	# We also want to not clobber newer devtmpfs setups.
	if [[ ${ROOT} == "/" ]] && \
	   ! awk '$2 == "/dev" && $3 == "devtmpfs" { exit 1 }' /proc/mounts ; then
		abort
	fi
}

pkg_postinst() {
	MAKEDEV -d "${ROOT}"/dev generic sg scd rtc hde hdf hdg hdh input audio video
}
