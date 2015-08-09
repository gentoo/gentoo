# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools-utils

DESCRIPTION="A tool to edit C strings in compiled binaries"
HOMEPAGE="http://ohnopub.net/~ohnobinki/bin_replace_string"
SRC_URI="ftp://mirror.ohnopub.net/mirror/${P}.tar.bz2"
LICENSE="AGPL-3"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="doc"

RDEPEND="|| ( >=dev-libs/libelf-0.8.13
		dev-libs/elfutils )"
DEPEND="doc? ( app-text/txt2man )
	${RDEPEND}"

src_configure() {
	local myeconfargs=(
		$(use_enable doc)
	)

	autotools-utils_src_configure
}
