# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/icclib/icclib-2.14.ebuild,v 1.1 2012/09/24 02:30:27 radhermit Exp $

EAPI=4

inherit base multilib toolchain-funcs

MY_P="${PN}_V${PV}"
DESCRIPTION="Library for reading and writing ICC color profile files"
HOMEPAGE="http://freecode.com/projects/icclib"
SRC_URI="http://www.argyllcms.com/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

S=${WORKDIR}

ICCLIB_SOVERSION="0"

PATCHES=(
	"${FILESDIR}/${P}-make.patch"
)

src_compile() {
	emake CC="$(tc-getCC)" ICCLIB_SOVERSION=${ICCLIB_SOVERSION}
}

src_install() {
	mv libicc.so libicc.so.${ICCLIB_SOVERSION} || die
	dolib.so libicc.so.${ICCLIB_SOVERSION}
	dosym libicc.so.${ICCLIB_SOVERSION} /usr/$(get_libdir)/libicc.so
	dobin iccdump
	dodoc Readme.txt todo.txt log.txt

	insinto /usr/include
	doins icc*.h
}
