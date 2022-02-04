# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A parallel port pin programming library"
HOMEPAGE="http://parapin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_/-}.tgz"
S="${WORKDIR}/${P/_/-}"

LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="doc"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-tc-directly.patch
)

src_compile() {
	tc-export AR CC
	# Note 2.4 and 2.6 makefiles are identical for the targets used
	emake -f Makefile-2.4
}

src_install() {
	einstalldocs
	dolib.a libparapin.a
	insopts -m0444;	insinto /usr/include; doins parapin.h

	if use doc; then
		cd examples || die
		docinto examples
		dodoc *.c
	fi
}
