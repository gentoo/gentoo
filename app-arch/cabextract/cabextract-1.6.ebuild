# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

DESCRIPTION="Extracts files from Microsoft cabinet archive files"
HOMEPAGE="http://www.cabextract.org.uk/"
SRC_URI="http://www.cabextract.org.uk/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="extras"

RDEPEND="extras? ( dev-lang/perl )"

# the code attempts to set up a fnmatch replacement, but then fails to code
# it properly leading to undefined references to rpl_fnmatch().  This may be
# removed in the future if building still works by setting "yes" to "no".
export ac_cv_func_fnmatch_works=yes

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog INSTALL NEWS README TODO doc/magic
	dohtml doc/wince_cab_format.html
	if use extras; then
		dobin src/{wince_info,wince_rename,cabinfo,cabsplit}
	fi
}
