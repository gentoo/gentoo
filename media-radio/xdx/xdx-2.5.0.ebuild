# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit eutils

DESCRIPTION="a GTK+ TCP/IP DX-cluster and ON4KST chat client"
HOMEPAGE="https://sourceforge.net/projects/xdxclusterclient"
SRC_URI="mirror://sourceforge/xdxclusterclient/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2.12:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}/"${P}-fno-common.patch )
DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs
}

pkg_postinst() {
	elog "To use the rig control feature, install media-libs/hamlib"
	elog "and enable hamlib in the Preferences dialog. (no need for recompile)"
}
