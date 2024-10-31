# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="EB is a C library and utilities for accessing CD-ROM books"
HOMEPAGE="https://web.archive.org/web/20120330123930/http://www.sra.co.jp/people/m-kasahr/eb/"
SRC_URI="ftp://ftp.sra.co.jp/pub/misc/eb/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~riscv sparc ~x86"
IUSE="nls threads"

RDEPEND="
	sys-libs/zlib
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

DOCS=( AUTHORS ChangeLog{,.0,.1,.2} NEWS README )

PATCHES=(
	"${FILESDIR}/eb-4.4-gcc14-iconv.patch" #920641
	"${FILESDIR}/eb-4.4.3-fix-threads.patch" #https://github.com/gentoo/gentoo/pull/37731#pullrequestreview-2218229971
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-ipv6
		$(use_enable nls)
		$(use_enable threads pthread)
		--with-pkgdocdir="${EPREFIX}"/usr/share/doc/${PF}/html
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
