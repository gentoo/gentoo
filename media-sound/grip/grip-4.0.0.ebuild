# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit flag-o-matic toolchain-funcs libtool

DESCRIPTION="GTK+ based Audio CD Player/Ripper"
HOMEPAGE="https://sourceforge.net/projects/grip/"
SRC_URI="mirror://sourceforge/grip/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="vorbis"

# lame and vorbis-tools are no real RDEPENDs. But without them
# grip cannot convert ripped files to any format. So use them as
# a sane default.
RDEPEND="
	dev-libs/glib:2
	gnome-base/libgnome
	>=gnome-base/libgnomeui-2.2.0
	>=media-libs/id3lib-3.8.3
	media-sound/cdparanoia
	media-sound/lame
	net-misc/curl
	>=x11-libs/gtk+-2.2:2
	x11-libs/libX11
	x11-libs/pango
	vorbis? ( media-sound/vorbis-tools )
"
# gnome-extra/yelp, see bug 416843
DEPEND="
	${RDEPEND}
	sys-devel/gettext
"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	sed '/^Icon/s@grip\b@gripicon@' -i grip.desktop || die
}

src_configure() {
	# Bug #69536
	[[ $(tc-arch) == "x86" ]] && append-flags "-mno-sse"

	strip-linguas be bg ca de en en_CA en_GB en_US es fi fr hu it ja nb nl pl_PL pt_BR ru sr vi zh_CN zh_HK zh_TW

	econf --disable-werror
}
