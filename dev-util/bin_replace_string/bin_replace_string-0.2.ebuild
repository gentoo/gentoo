# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/bin_replace_string/bin_replace_string-0.2.ebuild,v 1.1 2012/02/06 23:20:05 binki Exp $

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
