# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit autotools desktop wxwidgets

DESCRIPTION="A phylogenetic tree viewer"
HOMEPAGE="https://github.com/rdmpage/treeviewx"
COMMIT="7e4d0e96dfdde51a92a1634b41d7284142a19afa"
SRC_URI="https://github.com/rdmpage/treeviewx/archive/${COMMIT}.tar.gz -> ${P}.tar.gz
	mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_$(ver_cut 1-3)+git$(ver_cut 4).${COMMIT:0:7}-${PV/*_p}.debian.tar.xz
	https://dev.gentoo.org/~pacho/${PN}/${PN}_128.png"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/wxGTK:${WX_GTK_VER}[X]"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.1-AM_PROG_AR.patch
)

src_prepare() {
	default

	# Debian patches
	for p in $(<"${WORKDIR}"/debian/patches/series) ; do
		eapply -p1 "${WORKDIR}/debian/patches/${p}"
	done

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	setup-wxwidgets
	default
}

src_install() {
	default
	newicon -s 128 "${DISTDIR}"/${PN}_128.png ${PN}.png
	newicon bitmaps/treeview.xpm ${PN}.xpm
	make_desktop_entry tv "TreeView X"
}
