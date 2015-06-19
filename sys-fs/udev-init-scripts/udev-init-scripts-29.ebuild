# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/udev-init-scripts/udev-init-scripts-29.ebuild,v 1.1 2015/06/10 21:37:46 williamh Exp $

EAPI=5

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/udev-gentoo-scripts.git"
	inherit git-r3
else
	SRC_URI="http://dev.gentoo.org/~williamh/dist/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

inherit eutils

DESCRIPTION="udev startup scripts for openrc"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND=""
RDEPEND=">=virtual/udev-217
	!<sys-apps/openrc-0.14"

src_prepare() {
	epatch_user
}

pkg_postinst() {
	# Add udev and udev-trigger to the sysinit runlevel automatically.
	for f in udev udev-trigger; do
		if [[ -x ${ROOT%/}/etc/init.d/${f} &&
			-d ${ROOT%/}/etc/runlevels/sysinit &&
			! -L "${ROOT%/}/etc/runlevels/sysinit/${f}" ]]; then
			ln -snf /etc/init.d/${f} "${ROOT%/}"/etc/runlevels/sysinit/${f}
			ewarn "Adding ${f} to the sysinit runlevel"
		fi
	done

	if ! has_version "sys-fs/eudev[rule-generator]" && \
	[[ -x $(type -P rc-update) ]] && rc-update show | grep udev-postmount | grep -qs 'boot\|default\|sysinit'; then
		ewarn "The udev-postmount service has been removed because the reasons for"
		ewarn "its existance have been removed upstream."
		ewarn "Please remove it from your runlevels."
	fi
}
