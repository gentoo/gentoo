# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="HFS FS Access utils"
HOMEPAGE="https://www.mars.org/home/rob/proj/hfs/"
SRC_URI="
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p*}.orig.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV/_p/-}.debian.tar.xz
"
S="${WORKDIR}"/${P/_p*}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="tcl tk"
# Tests are enabled only with USE=tcl
RESTRICT="!tcl? ( test )"
# use tk requires tcl - bug #150437
REQUIRED_USE="tk? ( tcl )"

DEPEND="
	tcl? ( dev-lang/tcl:= )
	tk? ( dev-lang/tk:= )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/debian/patches
	"${FILESDIR}"/${P/_p*}-fix-tcl-8.6.patch
	"${FILESDIR}"/${PN}-3.2.6-test-tcl-8.6.patch
	"${FILESDIR}"/${PN}-3.2.6_p15-Include-string.h-for-strcmp.patch
	"${FILESDIR}"/${PN}-3.2.6_p15-drop-manual-autoconf.patch
)

src_prepare() {
	default

	sed -i -e 's:configure.in:configure.ac:' {libhfs/,librsrc/,}{configure,Makefile,config.h}.in || die

	eautoreconf
}

src_configure() {
	tc-export CC

	econf \
		$(use_with tcl tcl /usr/$(get_libdir) no) \
		$(use_with tk tk /usr/$(get_libdir) no)
}

src_compile() {
	emake AR="$(tc-getAR) rc" CC="$(tc-getCC)" RANLIB="$(tc-getRANLIB)"
	emake CC="$(tc-getCC)" -C hfsck
}

src_test() {
	# Tests reuse the same image name. Let's serialize.
	emake -j1 check
}

src_install() {
	dodir /usr/bin /usr/lib /usr/share/man/man1
	emake \
		prefix="${ED}"/usr \
		MANDEST="${ED}"/usr/share/man \
		infodir="${ED}"/usr/share/info \
		install
	dobin hfsck/hfsck
	dodoc BLURB CHANGES README TODO doc/*.txt
}
