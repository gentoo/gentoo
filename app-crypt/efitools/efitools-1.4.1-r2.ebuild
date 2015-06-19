# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/efitools/efitools-1.4.1-r2.ebuild,v 1.3 2015/01/30 09:21:05 pinkbyte Exp $

EAPI="4"
inherit eutils

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
	dev-perl/File-Slurp
	app-crypt/sbsigntool
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}"/xxdi.patch
	chmod 755 "${WORKDIR}/${P}/xxdi.pl"
}
