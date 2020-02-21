# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NDTP client written in Tcl/Tk"
HOMEPAGE="http://www.sra.co.jp/people/m-kasahr/bookview/"
SRC_URI="ftp://ftp.sra.co.jp/pub/net/ndtp/bookview/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="dev-lang/tk:0"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.diff )

src_install() {
	default
	dodoc ChangeLog.0

	insinto /etc/X11/app-defaults
	newins "${FILESDIR}/Bookview.ad" Bookview
}
