# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Library that handles Resource Description Framework (RDF)"
HOMEPAGE="https://librdf.org/rasqal/"
SRC_URI="https://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="+crypt gmp +mhash pcre static-libs test xml"
RESTRICT="!test? ( test )"

RDEPEND="
	>=media-libs/raptor-2.0.15
	crypt? (
		!mhash? ( dev-libs/libgcrypt:0 )
		mhash? ( app-crypt/mhash )
	)
	!gmp? ( dev-libs/mpfr:= )
	gmp? ( dev-libs/gmp:= )
	kernel_linux? ( >=sys-apps/util-linux-2.19 )
	pcre? ( dev-libs/libpcre )
	xml? ( dev-libs/libxml2 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=sys-devel/bison-3
	>=sys-devel/flex-2.5.36
	virtual/pkgconfig
	test? ( dev-perl/XML-DOM )
"

DOCS=( AUTHORS ChangeLog NEWS README )
HTML_DOCS=( {NEWS,README,RELEASE}.html )

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.33-configure-clang16.patch
	"${FILESDIR}"/${PN}-0.9.33-configure-c99.patch
)

src_prepare() {
	default

	#elibtoolize # g/fbsd .so versioning
	eautoreconf # for clang 16 patch
}

src_configure() {
	# FIXME: From 0.9.27 to .28 --with-random-approach= was introduced, do we
	# need a logic for it? Perhaps for dev-libs/gmp?
	local myeconfargs=(
		--with-decimal=$(usex gmp gmp mpfr)
		--with-uuid-library=$(usex kernel_linux libuuid internal)
		$(use_enable pcre)
		--with-regex-library=$(usex pcre pcre posix)
		$(use_enable static-libs static)
		$(use_enable xml xml2)
	)

	if use crypt; then
		myeconfargs+=( --with-digest-library=$(usex mhash mhash gcrypt) )
	else
		myeconfargs+=( --with-digest-library=internal )
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
