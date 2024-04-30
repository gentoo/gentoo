# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic desktop

DESCRIPTION="City simulation game for X"
HOMEPAGE="https://lincity.sourceforge.net/"
SRC_URI="
	https://downloads.sourceforge.net/lincity/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	media-libs/libpng:=
	virtual/libintl
	x11-libs/libXext"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="sys-devel/gettext"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-gcc-10.patch
	"${FILESDIR}"/${P}-Fix-prototypes-and-implicit-function-declarations.patch
)

src_prepare() {
	default

	# Clang 16, bug #899020
	eautoreconf
}

src_configure() {
	# bug #859220
	filter-lto

	local econfargs=(
		--with-gzip
		--with-x
		--without-svga
		ac_cv_lib_ICE_IceConnectionNumber=no # not actually used
	)

	econf "${econfargs[@]}"
}

src_compile() {
	emake
	emake X_PROGS
}

src_install() {
	default

	dobin x${PN}

	newman {,x}${PN}.6
	rm "${ED}"/usr/share/man/man6/${PN}.6

	dodoc Acknowledgements

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry x${PN} ${PN^}
}
