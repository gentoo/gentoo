# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}_V${PV}"

DESCRIPTION="Library for reading and writing ICC color profile files"
HOMEPAGE="http://freecode.com/projects/icclib"
SRC_URI="http://www.argyllcms.com/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

PATCHES=( "${FILESDIR}"/${P}-make.patch )

src_compile() {
	ICCLIB_SOVERSION="0"
	emake CC="$(tc-getCC)" ICCLIB_SOVERSION="${ICCLIB_SOVERSION}"
}

src_install() {
	dobin iccdump

	mv libicc.so libicc.so.${ICCLIB_SOVERSION} || die
	dolib.so libicc.so.${ICCLIB_SOVERSION}
	dosym libicc.so.${ICCLIB_SOVERSION} /usr/$(get_libdir)/libicc.so

	doheader icc*.h

	dodoc Readme.txt todo.txt log.txt
}
