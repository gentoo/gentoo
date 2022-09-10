# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools libtool multilib-minimal

MY_PN=${PN}2
MY_P=${MY_PN}-${PV}

DESCRIPTION="The RDF Parser Toolkit"
HOMEPAGE="https://librdf.org/raptor/"
SRC_URI="https://download.librdf.org/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="+curl debug json static-libs unicode"

DEPEND="
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	dev-libs/libxslt[${MULTILIB_USEDEP}]
	curl? ( net-misc/curl[${MULTILIB_USEDEP}] )
	json? ( dev-libs/yajl[${MULTILIB_USEDEP}] )
	unicode? ( dev-libs/icu:=[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}
	!media-libs/raptor:0
"
BDEPEND="
	>=sys-devel/bison-3
	>=sys-devel/flex-2.5.36
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog NEWS NOTICE README )
HTML_DOCS=( {NEWS,README,RELEASE,UPGRADING}.html )

PATCHES=(
	"${FILESDIR}/${P}-heap-overflow.patch"
	"${FILESDIR}/${P}-dont_use_curl-config.patch" #552474
	"${FILESDIR}/0001-CVE-2020-25713-raptor2-malformed-input-file-can-lead.patch"
)

src_prepare() {
	default
	eautoreconf #552474
	elibtoolize # Keep this for ~*-fbsd
	multilib_copy_sources
}

multilib_src_configure() {
	# FIXME: It should be possible to use net-nntp/inn for libinn.h and -linn!

	local myeconfargs=(
		--with-html-dir="${EPREFIX}"/usr/share/gtk-doc/html
		$(usex curl --with-www=curl --with-www=xml)
		$(use_enable debug)
		$(use_with json yajl)
		$(use_enable static-libs static)
		$(usex unicode --with-icu-config="${EPREFIX}"/usr/bin/icu-config '')
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
