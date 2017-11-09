# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

MY_PV="${PV%*.*}"

DESCRIPTION="Unix shell embedded in Scheme"
HOMEPAGE="http://www.scsh.net/"
SRC_URI="ftp://ftp.scsh.net/pub/scsh/${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

DEPEND="!dev-scheme/scheme48"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-Makefile.in-doc-dir-gentoo.patch"
	"${FILESDIR}/${PV}-Makefile.in-LDFLAGS.patch"
	"${FILESDIR}/${PV}-Missing-includes.patch"
)

RESTRICT="test" # some tests don't pass.

src_prepare() {
	default
}

src_configure() {
	use amd64 && multilib_toolchain_setup x86
	SCSH_LIB_DIRS="/usr/$(get_libdir)/${PN}"
	econf \
		--libdir=/usr/$(get_libdir) \
		--includedir=/usr/include \
		--with-lib-dirs-list=${SCSH_LIB_DIRS}
}

src_install() {
	emake -j1 DESTDIR="${D}" install
	local ENVD="${T}/50scsh"
	echo "SCSH_LIB_DIRS=\"${SCSH_LIB_DIRS}\"" > "${ENVD}" || die
	doenvd "${ENVD}"
}
