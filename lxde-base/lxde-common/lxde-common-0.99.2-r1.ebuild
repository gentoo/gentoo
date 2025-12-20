# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LXDE Session default configuration files and nuoveXT2 iconset"
HOMEPAGE="https://wiki.lxde.org/en/LXDE_Common"
SRC_URI="https://downloads.sourceforge.net/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"
IUSE=""

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
PDEPEND="lxde-base/lxde-icon-theme"

src_install() {
	emake DESTDIR="${D}" install
	# install session file
	insinto /etc/X11/Sessions/
	doins "${FILESDIR}/lxde"
	fperms 755 /etc/X11/Sessions/lxde
	dodoc AUTHORS ChangeLog README
}
