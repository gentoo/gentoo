# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic vcs-clean

DESCRIPTION="GTK+2 Soccer Management Game"
HOMEPAGE="https://bygfoot.sourceforge.io/new/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-arch/zip
	media-libs/freetype:2
	x11-libs/gtk+:2
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/859232
	#
	# Upstream sourceforge is inactive since 2021, and even that was a java port.
	# The gtk / C project was last touched in 2014. Even if upstream was still
	# around, it does not seem worth discussing the production C version.
	filter-lto

	econf --disable-gstreamer
}

src_install() {
	default
	dodoc UPDATE

	esvn_clean "${D}"

	newicon support_files/pixmaps/bygfoot_icon.png ${PN}.png
	make_desktop_entry ${PN} Bygfoot
}
