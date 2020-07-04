# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kernel-install

# Variables
_LV="FC.01"                     # Local Version
_PLV="${PV}-${_LV}"             # Package Version + Local Version (Module Dir)

# Main
DESCRIPTION="Precompiled Vanilla Kernel (Kernel Ready-to-Eat [KRE])"
HOMEPAGE="https://wiki.gentoo.org/wiki/User:Fearedbliss"
SRC_URI="https://xyinn.org/gentoo/kernels/${_PLV}/kernel-${_PLV}.tar.xz"

RESTRICT="strip test"
LICENSE="GPL-2"
SLOT="${_PLV}"
KEYWORDS="-* amd64"

# Unset 'initramfs' since 'bliss-kernel' doesn't need them
# as an explicitly enabled IUSE from the kernel-install eclass.
IUSE="-initramfs"

S="${WORKDIR}"
QA_PREBUILT="*"

src_install() {
	mv * "${ED}" || die
}

pkg_postinst() {
	# Stub out this function. The downloaded tarball is ready to be installed
	# into the OS directly.
	debug-print-function ${FUNCNAME} "${@}"
}
