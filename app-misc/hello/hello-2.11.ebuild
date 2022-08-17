# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="GNU \"Hello, world\" application"
HOMEPAGE="https://www.gnu.org/software/hello/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="FDL-1.3 GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="nls"

DOCS=(AUTHORS ChangeLog ChangeLog.O NEWS README THANKS TODO contrib/evolution.txt)

src_configure() {
	econf $(use_enable nls)
}
