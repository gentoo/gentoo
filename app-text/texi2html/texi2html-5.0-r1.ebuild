# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit prefix

DESCRIPTION="Perl script that converts Texinfo to HTML"
HOMEPAGE="http://www.nongnu.org/texi2html/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ || ( GPL-2 CC-BY-SA-1.0 ) Texinfo-manual LGPL-2+ MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="unicode"

RDEPEND=">=dev-lang/perl-5.10.1
	>=dev-perl/libintl-perl-1.200
	unicode? (
		dev-perl/Text-Unidecode
		dev-perl/Unicode-EastAsianWidth
		)"
DEPEND="${RDEPEND}"

DOCS="AUTHORS ChangeLog NEWS README TODO"

RESTRICT="test" #411523

src_prepare() {
	# On FreeBSD this script is used instead of GNU install but it comes without
	# executable pemissions... Fix it!
	chmod +x install-sh || die

	if use prefix; then
		hprefixify $(find . -name '*.pl' | xargs)
	fi
}

src_configure() {
	local myconf
	use unicode && myconf='--with-external-Unicode-EastAsianWidth'

	econf \
		--with-external-libintl-perl \
		$(use_with unicode unidecode) \
		${myconf}
}

src_install() {
	default
	rm -f "${ED}"/usr/share/${PN}/images/{COPYING*,GPL,README}
}

pkg_preinst() {
	rm -f "${EROOT}"/usr/bin/${PN}
}
