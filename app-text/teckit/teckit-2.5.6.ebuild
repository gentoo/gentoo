# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils

DESCRIPTION="Text Encoding Conversion toolkit"
HOMEPAGE="http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&cat_id=TECkit"
SRC_URI="https://github.com/silnrsi/teckit/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( CPL-0.5 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib
	dev-libs/expat"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-2.5.1-mixcflagscxxflags.patch"
	rm -f configure
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS README NEWS
}

src_test() {
	cd "${S}/test"
	chmod +x dotests.pl
	./dotests.pl || die "tests failed"
}
