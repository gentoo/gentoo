# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="Image loading and rendering library"
HOMEPAGE="https://ftp.acc.umu.se/pub/GNOME/sources/imlib/1.9/"
SRC_URI="mirror://gnome/sources/${PN}/$(ver_cut 1-2)/${P}.tar.bz2
	mirror://gentoo/gtk-1-for-imlib.m4.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="static-libs"

RDEPEND="
	>=media-libs/tiff-3.9.7-r1:=[${MULTILIB_USEDEP}]
	>=media-libs/giflib-5.1:0=[${MULTILIB_USEDEP}]
	media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}]
	>=media-libs/libpng-1.2.51:=[${MULTILIB_USEDEP}]
	>=x11-libs/libICE-1.0.8-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libSM-1.2.1-r1[${MULTILIB_USEDEP}]
	>=x11-libs/libXext-1.3.2[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"

PATCHES=(
	# Fix aclocal underquoted definition warnings.
	# Conditionalize gdk functions for bug 40453.
	# Fix imlib-config for bug 3425.
	"${FILESDIR}"/${P}.patch
	"${FILESDIR}"/${PN}-security.patch #security #72681
	"${FILESDIR}"/${P}-bpp16-CVE-2007-3568.patch # security #201887
	"${FILESDIR}"/${P}-fix-rendering.patch #197489
	"${FILESDIR}"/${P}-asneeded.patch #207638
	"${FILESDIR}"/${P}-libpng15.patch #357167
	"${FILESDIR}"/${P}-underlinking-test.patch #367645
	"${FILESDIR}"/${P}-no-LDFLAGS-in-pc.patch
	"${FILESDIR}"/${P}-giflib51-{1,2}.patch #538976
	"${FILESDIR}"/${P}-c99-configure.patch #898234
)

src_prepare() {
	default

	mkdir m4 && cp "${WORKDIR}"/gtk-1-for-imlib.m4 m4 || die
	AT_M4DIR="m4" eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--sysconfdir=/etc/imlib
		$(use_enable static-libs static)
		--disable-gdk
		--disable-gtktest
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	# fix target=@gdk-target@ in pkgconfig, bug #499268
	sed -e '/^target=/d' \
		-i "${ED}"/usr/$(get_libdir)/pkgconfig/imlib.pc || die
}

multilib_src_install_all() {
	local HTML_DOCS=( doc/*.gif doc/*.html )
	einstalldocs

	# Punt unused files
	rm -f "${D}"/usr/lib*/pkgconfig/imlibgdk.pc || die
	find "${D}" -name '*.la' -delete || die
}
