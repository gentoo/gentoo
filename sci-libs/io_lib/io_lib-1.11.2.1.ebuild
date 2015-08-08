# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="A general purpose trace and experiment file reading/writing interface"
HOMEPAGE="http://staden.sourceforge.net/"
SRC_URI="mirror://sourceforge/staden/${P}.tar.gz"
LICENSE="staden"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

# Prototype changes in io_lib-1.9.0 create incompatibilities with BioPerl. (Only
# versions 1.8.11 and 1.8.12 will work with the BioPerl Staden extensions.)
DEPEND="!sci-biology/bioperl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-1.11.2"

src_install() {
	make install DESTDIR="${D}" || die

	dodoc ChangeLog CHANGES README docs/{Hash_File_Format,ZTR_format} || \
			die "Failed to install documentation."
}
