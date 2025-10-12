# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal toolchain-funcs

DESCRIPTION="GNU VCDimager"
HOMEPAGE="https://www.gnu.org/software/vcdimager/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc x86"
IUSE="static-libs +xml"

RDEPEND="
	>=dev-libs/libcdio-2.0.0:=[-minimal,${MULTILIB_USEDEP}]
	dev-libs/popt
	xml? ( dev-libs/libxml2:2= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS BUGS ChangeLog FAQ HACKING NEWS README THANKS TODO )

PATCHES=(
	"${FILESDIR}/${P}-pkg-config.patch"
	"${FILESDIR}/${PN}-2.0.1-libxml2-2.14.patch"
)

src_prepare() {
	default

	# Avoid building useless programs (bug #226249)
	sed -i \
		-e 's/check_PROGRAMS =/check_PROGRAMS +=/' \
		-e 's/noinst_PROGRAMS =/check_PROGRAMS =/' \
		test/Makefile.am || die
	sed -i \
		-e 's/noinst_PROGRAMS =/check_PROGRAMS =/' \
		example/Makefile.am || die

	# Don't call nm directly (bug #724838)
	sed -i \
		-e "s|nm|$(tc-getNM)|" \
		lib/Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(multilib_native_with cli-frontend)
		$(multilib_native_use_with xml xml-frontend)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	emake -j1 check
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
	einstalldocs
}
