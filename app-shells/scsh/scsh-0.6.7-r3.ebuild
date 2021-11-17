# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib

MY_PV="${PV%*.*}"

DESCRIPTION="Unix shell embedded in Scheme"
HOMEPAGE="https://www.scsh.net/"
SRC_URI="ftp://ftp.scsh.net/pub/scsh/${MY_PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

DEPEND="
	!dev-scheme/scheme48
	virtual/libcrypt:=
	amd64? ( virtual/libcrypt:=[abi_x86_32] )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PV}-Makefile.in-LDFLAGS.patch"
	"${FILESDIR}/${PV}-Makefile.in-AR.patch"
	"${FILESDIR}/${PV}-Makefile.in-doc-dir-gentoo.patch"
	"${FILESDIR}/${PV}-Missing-includes.patch"
)

RESTRICT="test"

src_configure() {
	use amd64 && multilib_toolchain_setup x86

	export SCSH_LIB_DIRS="/usr/$(get_libdir)/${PN}"

	local myconf=(
		--includedir=/usr/include
		--libdir=/usr/$(get_libdir)
		--with-lib-dirs-list=${SCSH_LIB_DIRS}
	)
	econf "${myconf[@]}"
}

src_install() {
	emake -j1 DESTDIR="${D}" install

	# Fix doc install dir
	mv "${ED}/usr/share/doc/${PN}-${PV}" "${ED}/usr/share/doc/${PF}" || die

	local ENVD="${T}/50scsh"
	echo "SCSH_LIB_DIRS='\"${SCSH_LIB_DIRS}\"'" > "${ENVD}" || die
	doenvd "${ENVD}"
}
