# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit xorg-2

DESCRIPTION="X Session Manager"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="rsh"
RDEPEND="x11-libs/libXaw
	x11-libs/libX11
	x11-libs/libXt
	x11-libs/libICE
	x11-libs/libSM
	rsh? ( net-misc/netkit-rsh )"
DEPEND="${RDEPEND}"

pkg_setup() {
	# (#158056) /usr/$(get_libdir)/X11/xsm could be a symlink
	local XSMPATH="${EROOT}usr/$(get_libdir)/X11/xsm"
	if [[ -L ${XSMPATH} ]]; then
		einfo "Removing symlink ${XSMPATH}"
		rm -f ${XSMPATH} || die "failed to remove symlink ${XSMPATH}"
	fi
	xorg-2_pkg_setup
}

src_configure() {
	XORG_CONFIGURE_OPTIONS="$(use_with rsh rsh /usr/bin/rsh)"
	xorg-2_src_configure
}
