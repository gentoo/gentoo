# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="General purpose trace and experiment file reading/writing interface"
HOMEPAGE="http://staden.sourceforge.net/"
SRC_URI="mirror://sourceforge/staden/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/11"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	app-arch/bzip2:=
	app-arch/xz-utils:=
	net-misc/curl:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"

# tests fails and might need sci-biology/staden from
# the science overlay
RESTRICT="test"

src_configure() {
	econf $(use static-libs static)
}

src_install() {
	default
	dodoc docs/{Hash_File_Format,ZTR_format}

	if ! use static-libs; then
		find "${D}" \( -name '*.la' -o -name '*.a' \) -delete || die
	fi
}
