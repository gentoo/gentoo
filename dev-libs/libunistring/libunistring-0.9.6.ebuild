# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Library for manipulating Unicode strings and C strings according to the Unicode standard"
HOMEPAGE="https://www.gnu.org/software/libunistring/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 GPL-3"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux"
IUSE="doc static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-nodocs.patch
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	if use doc; then
		dohtml doc/*.html
		doinfo doc/*.info
	fi

	prune_libtool_files
}
