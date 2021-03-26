# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="Library for mp3splt to split mp3 and ogg files without decoding"
HOMEPAGE="http://mp3splt.sourceforge.net/mp3splt_page/home.php"
SRC_URI="mirror://sourceforge/${PN:3}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc flac pcre"

RDEPEND="
	media-libs/libmad
	media-libs/libid3tag
	media-libs/libogg
	media-libs/libvorbis
	flac? ( media-libs/flac )
	pcre? ( dev-libs/libpcre )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/findutils
	doc? (
		>=app-doc/doxygen-1.8.3.1
		media-gfx/graphviz
	)
"

DOCS=( AUTHORS ChangeLog LIMITS NEWS README TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.2-drop-libltdl.patch
	"${FILESDIR}"/${PN}-0.9.2-fix-implicit-decl.patch
	"${FILESDIR}"/CVE-2017-15185.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Breaks consumers like media-sound/libmp3splt otherwise
	# bug #778476
	append-libs -ldl

	local myeconfargs=(
		--disable-cutter # TODO package cutter <http://cutter.sourceforge.net/>
		--disable-optimise
		--disable-static
		$(use_enable doc doxygen_doc)
		$(use_enable flac)
		$(use_enable pcre)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	use doc && docompress -x /usr/share/doc/${PF}/doxygen/${PN}_ico.svg

	find "${ED}" -type f -name '*.la' -delete || die
}
