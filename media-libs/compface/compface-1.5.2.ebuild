# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools

DESCRIPTION="Utilities and library to convert to/from X-Face format"
HOMEPAGE="http://www.xemacs.org/Download/optLibs.html"
SRC_URI="http://ftp.xemacs.org/pub/xemacs/aux/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="dev-lang/perl"

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	newbin xbm2xface{.pl,}
}
