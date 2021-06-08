# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Tools for manipulating signed PE-COFF binaries"
HOMEPAGE="https://github.com/rhboot/pesign"
SRC_URI="https://github.com/rhboot/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/nspr
	dev-libs/nss
	dev-libs/openssl:0=
	dev-libs/popt
	sys-apps/util-linux
	sys-libs/efivar
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	sys-boot/gnu-efi
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-113-nss.patch
	"${FILESDIR}"/${PN}-113-enum-conversion.patch
)

src_configure() {
	append-cflags -O1 #721934
	default
}

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
	rm -rf "${ED}/etc" "${ED}/var" "${ED}/usr/share/doc/${PF}/COPYING" || die
}
