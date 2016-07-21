# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Tools for manipulating UEFI secure boot platforms"
HOMEPAGE="https://git.kernel.org/cgit/linux/kernel/git/jejb/efitools.git"
SRC_URI="https://build.opensuse.org/package/rawsourcefile/home:jejb1:UEFI/efitools/efitools-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl
	sys-apps/util-linux"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig"
