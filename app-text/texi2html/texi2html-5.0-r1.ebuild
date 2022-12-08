# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit prefix

DESCRIPTION="Perl script that converts Texinfo to HTML"
HOMEPAGE="http://www.nongnu.org/texi2html/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ || ( GPL-2 CC-BY-SA-1.0 ) Texinfo-manual LGPL-2+ MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="unicode"
RESTRICT="test" #411523

RDEPEND="
	dev-lang/perl
	dev-perl/libintl-perl
	unicode? (
		dev-perl/Text-Unidecode
		dev-perl/Unicode-EastAsianWidth
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	# On FreeBSD this script is used instead of GNU install but it comes without
	# executable pemissions... Fix it!
	chmod +x install-sh || die

	if use prefix; then
		local f
		while IFS="" read -d $'\0' -r f ; do
			hprefixify "${f}"
		done < <(find . -name '*.pl' -print0)
	fi
}

src_configure() {
	use unicode && local myconf='--with-external-Unicode-EastAsianWidth'

	econf \
		--with-external-libintl-perl \
		$(use_with unicode unidecode) \
		${myconf}
}

src_install() {
	default
	rm "${ED}"/usr/share/${PN}/images/{COPYING*,GPL,README} || die
}

pkg_preinst() {
	rm -f "${EROOT}"/usr/bin/${PN} || die
}
