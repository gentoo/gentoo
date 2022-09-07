# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Spectrum emulation library"
HOMEPAGE="http://fuse-emulator.sourceforge.net/libspectrum.php"
SRC_URI="mirror://sourceforge/fuse-emulator/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="audiofile bzip2 gcrypt zlib"

RDEPEND="dev-libs/glib:2
	audiofile? ( >=media-libs/audiofile-0.3.6 )
	bzip2? ( >=app-arch/bzip2-1.0 )
	gcrypt? ( dev-libs/libgcrypt:0 )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/perl
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/remove-local-prefix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--disable-static
		$(use_with audiofile libaudiofile)
		$(use_with bzip2)
		$(use_with gcrypt libgcrypt)
		$(use_with zlib)
	)
	econf "${myconf[@]}"
}

src_test() {
	# check only builds test executable but doesn't run it
	emake check
	./test/test || die
}

src_install() {
	default
	dodoc doc/*.txt *.txt
	find "${ED}" -type f -name "*.la" -delete || die
}
