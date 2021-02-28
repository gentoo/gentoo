# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Text Encoding Conversion toolkit"
HOMEPAGE="http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&cat_id=TECkit"
SRC_URI="https://github.com/silnrsi/teckit/releases/download/v${PV}/${P}.tar.gz"

LICENSE="|| ( CPL-0.5 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	dev-libs/expat
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	rm -f configure || die

	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_test() {
	cd "${S}/test" || die
	chmod +x dotests.pl || die
	./dotests.pl || die "tests failed"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS README NEWS
	find "${ED}" -name '*.la' -delete || die
}
