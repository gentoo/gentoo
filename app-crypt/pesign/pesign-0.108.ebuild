# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="Tools for manipulating signed PE-COFF binaries"
HOMEPAGE="https://github.com/vathpela/pesign"
SRC_URI="https://github.com/vathpela/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/nspr
	dev-libs/openssl:0
	sys-apps/util-linux
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/destdir.patch
}

src_install() {
	default

	# remove some files that don't make sense for Gentoo installs
	rm -rf "${ED}/etc/" "${ED}/usr/share/doc/pesign/" || die

	# create .so symlink
	ln -s libdpe.so "${ED}/usr/$(get_libdir)/libdpe.so.0"
}
#
#src_prepare() {
#	local iarch
#	case ${ARCH} in
#		ia64)  iarch=ia64 ;;
#		x86)   iarch=ia32 ;;
#		amd64) iarch=x86_64 ;;
#		*)     die "unsupported architecture: ${ARCH}" ;;
#	esac
#	sed -i "/^EFI_ARCH=/s:=.*:=${iarch}:" configure || die
#	sed -i 's/-m64$/& -march=x86-64/' tests/Makefile.in || die
#}
