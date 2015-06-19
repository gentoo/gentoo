# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/io_lib/io_lib-1.13.2.ebuild,v 1.1 2013/07/16 16:38:10 bicatali Exp $

EAPI=5

inherit autotools-utils

DESCRIPTION="General purpose trace and experiment file reading/writing interface"
HOMEPAGE="http://staden.sourceforge.net/"
SRC_URI="mirror://sourceforge/staden/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

# needs stadden, not in portage
RESTRICT=test
# Prototype changes in io_lib-1.9.0 create incompatibilities with BioPerl. (Only
# versions 1.8.11 and 1.8.12 will work with the BioPerl Staden extensions.)
#DEPEND="!sci-biology/bioperl"
DEPEND="
	net-misc/curl
	sys-libs/zlib"
RDEPEND="${DEPEND}"

src_install() {
	autotools-utils_src_install
	dodoc docs/{Hash_File_Format,ZTR_format}
}
