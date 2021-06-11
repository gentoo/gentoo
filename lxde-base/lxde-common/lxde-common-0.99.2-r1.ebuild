# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="LXDE Session default configuration files and nuoveXT2 iconset"
HOMEPAGE="https://wiki.lxde.org/en/LXDE_Common"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~x86 ~x86-linux"
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
