# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev-init-scripts/udev-init-scripts-27.ebuild,v 1.10 2015/04/25 16:40:29 floppym Exp $

EAPI=5

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/udev-gentoo-scripts.git"
	inherit git-r3
else
	SRC_URI="http://dev.gentoo.org/~williamh/dist/${P}.tar.bz2"
	KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
fi

inherit eutils

DESCRIPTION="udev startup scripts for openrc"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="test"

RDEPEND=">=virtual/udev-180
	!<sys-fs/udev-186
	!<sys-apps/openrc-0.13"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
}

pkg_postinst() {
	# Add udev to the sysinit runlevel automatically if this is
	# the first install of this package.
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		if [[ ! -d ${ROOT%/}/etc/runlevels/sysinit ]]; then
			mkdir -p "${ROOT%/}"/etc/runlevels/sysinit
		fi
		if [[ -x ${ROOT%/}/etc/init.d/udev ]]; then
			ln -s /etc/init.d/udev "${ROOT%/}"/etc/runlevels/sysinit/udev
		fi
	fi

	# Warn the user about adding udev to their sysinit runlevel
	if [[ -e ${ROOT%/}/etc/runlevels/sysinit ]]; then
		if [[ ! -e ${ROOT%/}/etc/runlevels/sysinit/udev ]]; then
			ewarn
			ewarn "You need to add udev to the sysinit runlevel."
			ewarn "If you do not do this,"
			ewarn "your system will not be able to boot!"
			ewarn "Run this command:"
			ewarn "\trc-update add udev sysinit"
		fi
	fi

	if ! has_version "sys-fs/eudev[rule-generator]" && \
	[[ -x $(type -P rc-update) ]] && rc-update show | grep udev-postmount | grep -qs 'boot\|default\|sysinit'; then
		ewarn "The udev-postmount service has been removed because the reasons for"
		ewarn "its existance have been removed upstream."
		ewarn "Please remove it from your runlevels."
	fi
}
