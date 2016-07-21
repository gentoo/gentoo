# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="General purpose trace and experiment file reading/writing interface"
HOMEPAGE="http://staden.sourceforge.net/"
SRC_URI="mirror://sourceforge/staden/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

DEPEND="
	net-misc/curl
	sys-libs/zlib"
RDEPEND="${DEPEND}"

# tests fails and might need sci-biology/staden from
# the science overlay

RESTRICT="test"

src_configure() {
	econf $(use static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files
	dodoc docs/{Hash_File_Format,ZTR_format}
}
