# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit xorg-2

EGIT_REPO_URI="git://anongit.freedesktop.org/git/mesa/drm"

DESCRIPTION="X.Org libdrm library"
HOMEPAGE="http://dri.freedesktop.org/"
if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="http://dri.freedesktop.org/${PN}/${P}.tar.bz2"
fi

KEYWORDS="~x86-fbsd"
IUSE="kernel_linux"
RESTRICT="test" # see bug #236845

RDEPEND="dev-libs/libpthread-stubs"
DEPEND="${RDEPEND}"

PATCHES=(
	# Fixes buidling of x11-drivers/xf86-video-openchrome, Gentoo bug 298352,
	# upstream bug 26994
	"${FILESDIR}"/2.4.18-0001-datatypes.patch
	)

pkg_setup() {
	# libdrm_intel fails to build on some arches if dev-libs/libatomic_ops is
	# installed, bugs 297630, bug 316421 and bug 316541, and is presently only
	# useful on amd64 and x86.
	CONFIGURE_OPTIONS="--enable-udev
			--enable-nouveau-experimental-api
			--enable-vmwgfx-experimental-api
			$(use_enable kernel_linux libkms)
			$(! use amd64 && ! use x86 && ! use x86-fbsd && echo "--disable-intel")"
}

pkg_postinst() {
	x-modular_pkg_postinst

	ewarn "libdrm's ABI may have changed without change in library name"
	ewarn "Please rebuild media-libs/mesa, x11-base/xorg-server and"
	ewarn "your video drivers in x11-drivers/*."
}
