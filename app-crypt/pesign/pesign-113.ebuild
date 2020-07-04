# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils toolchain-funcs

DESCRIPTION="Tools for manipulating signed PE-COFF binaries"
HOMEPAGE="https://github.com/rhboot/pesign"
SRC_URI="https://github.com/rhboot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	dev-libs/nspr
	dev-libs/nss
	dev-libs/popt
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	sys-apps/util-linux
	sys-libs/efivar
"
DEPEND="${RDEPEND}
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}"/${PN}-113-nss.patch )

src_compile() {
	emake AR="$(tc-getAR)" \
		ARFLAGS="-cvqs" \
		AS="$(tc-getAS)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	emake DESTDIR="${ED}" VERSION="${PVR}" install
	einstalldocs

	# remove some files that don't make sense for Gentoo installs
	rm -rf "${ED%/}/etc/" "${ED%/}/var/" \
		"${ED%/}/usr/share/doc/${PF}/COPYING" || die
}
