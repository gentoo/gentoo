# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

DESCRIPTION="The RDF Parser Toolkit"
HOMEPAGE="https://librdf.org/raptor/"
SRC_URI="https://download.librdf.org/source/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="debug json static-libs"

DEPEND="
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	dev-libs/libxslt[${MULTILIB_USEDEP}]
	dev-libs/icu:=[${MULTILIB_USEDEP}]
	net-misc/curl[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	json? ( dev-libs/yajl[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	!media-libs/raptor:0
"
BDEPEND="
	>=sys-devel/bison-3
	app-alternatives/lex
	virtual/pkgconfig
"

DOCS=( AUTHORS ChangeLog NEWS NOTICE README )
HTML_DOCS=( {NEWS,README,RELEASE,UPGRADING}.html )

PATCHES=(
	"${FILESDIR}/raptor-2.0.16-dont_use_curl-config.patch" #552474
	"${FILESDIR}/raptor-2.0.16-libxml2-2.11-compatibility.patch"
)

src_prepare() {
	default

	# bug #552474
	eautoreconf

	multilib_copy_sources
}

multilib_src_configure() {
	# FIXME: It should be possible to use net-nntp/inn for libinn.h and -linn!

	local myeconfargs=(
		--with-html-dir="${EPREFIX}"/usr/share/gtk-doc/html
		--with-www=curl
		$(use_enable debug)
		$(use_with json yajl)
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}

multilib_src_test() {
	emake -j1 test
}

multilib_src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
