# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/teckit/teckit-2.5.3.ebuild,v 1.2 2015/07/15 15:10:16 aballier Exp $

EAPI=5

inherit autotools eutils

MY_P=TECkit_${PV}
DESCRIPTION="Text Encoding Conversion toolkit"
HOMEPAGE="http://scripts.sil.org/cms/scripts/page.php?site_id=nrsi&cat_id=TECkit"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
# Upstream regenerates tarballs at each fetch, breaking checksums:
# SRC_URI="http://scripts.sil.org/svn-view/teckit/TAGS/${MY_P}.tar.gz"
# https://bugs.gentoo.org/show_bug.cgi?id=554972

LICENSE="|| ( CPL-0.5 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="sys-libs/zlib
	dev-libs/expat"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

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
