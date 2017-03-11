# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/udev-gentoo-scripts.git"
	inherit git-r3
else
	SRC_URI="https://dev.gentoo.org/~williamh/dist/${P}.tar.gz"
	KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"
fi

DESCRIPTION="udev startup scripts for openrc"
HOMEPAGE="https://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RESTRICT="test"

DEPEND=""
RDEPEND=">=virtual/udev-217
	!<sys-apps/openrc-0.14"

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
