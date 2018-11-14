# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apparmor +chroot contrib +file-transfer +network
	+seccomp suid +userns x11"

DEPEND="!sys-apps/firejail-lts
	apparmor? ( sys-libs/libapparmor )"
RDEPEND="${DEPEND}
	x11? ( x11-wm/xpra[client,server] )"

PATCHES=( "${FILESDIR}/${PV}-contrib-fix.patch" )

RESTRICT=test

src_prepare() {
	default
	find -name Makefile.in -exec sed -i -r \
			-e '/^\tinstall .*COPYING /d' \
			-e '/CFLAGS/s: (-O2|-ggdb) : :g' \
			-e '1iCC=@CC@' {} + || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable apparmor)
		$(use_enable chroot)
		$(use_enable contrib contrib-install)
		$(use_enable file-transfer)
		$(use_enable network)
		$(use_enable seccomp)
		$(use_enable suid)
		$(use_enable userns)
		$(use_enable x11)
	)
	econf "${myeconfargs[@]}"
}
