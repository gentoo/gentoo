# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Author a DVD-Audio DVD"
HOMEPAGE="https://dvd-audio.sourceforge.net"
SRC_URI="mirror://sourceforge/dvd-audio/${P}-300.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	media-libs/flac:=[ogg]
	media-sound/sox[png]
"
DEPEND="${RDEPEND}"
BDEPEND="dev-build/libtool"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-desktop-QA.patch
)

src_prepare() {
	default

	# Fix parallel make
	sed -i -e 's:^\(\tcd ${MAYBE_CDRTOOLS}\):@HAVE_CDRTOOLS_BUILD_TRUE@\1:' \
		Makefile.in || die "sed failed"

	# Don't pre-strip binaries
	sed -i -e 's:$LIBS -s:$LIBS:' configure || die "sed failed"

	# Fix up --as-needed.
	MY_AS_NEEDED_F='$(LINK) \($(dvda_OBJECTS)\)'
	MY_AS_NEEDED_R='$(CCLD) $(AM_CFLAGS) $(CFLAGS) \1 $(AM_LDFLAGS) $(LDFLAGS) -o $@'
	sed -i -e "s/${MY_AS_NEEDED_F}/${MY_AS_NEEDED_R}/" src/Makefile.in || die "sed failed"
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/860516
	#
	# Upstream on sourceforge is inactive for several years now. No bug filed.
	filter-lto

	econf \
		--with-config="${EPREFIX}/etc" \
		$(use_with debug debug full)
}

src_compile() {
	emake AR="$(tc-getAR)" all
}

src_install() {
	default

	domenu "${ED}"/etc/dvda-author.desktop
	rm -r "${ED}"/etc/{menu,dvda-author.desktop} || die
}
