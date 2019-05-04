# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
OLD_PN=udev-gentoo-scripts
OLD_P=${OLD_PN}-${PV}

if [ "${PV}" = "9999" ]; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/${OLD_PN}.git"
	inherit git-r3
else
	SRC_URI="https://gitweb.gentoo.org/proj/${OLD_PN}.git/snapshot/${OLD_P}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${OLD_P}"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv s390 ~sh ~sparc ~x86"
fi

DESCRIPTION="udev startup scripts for openrc"
HOMEPAGE="https://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0"

RESTRICT="test"

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
