# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Execute a command when the contents of a directory change"
HOMEPAGE="https://directory.fsf.org/project/dnotify/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc -sparc x86"
IUSE="nls"

BDEPEND="nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-nls.patch"
	"${FILESDIR}/${P}-glibc-212.patch"
	"${FILESDIR}/${P}-fix-implicit-declarations.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}
