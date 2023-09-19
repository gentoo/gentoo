# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Real-time satellite tracking and orbit prediction application"
HOMEPAGE="http://gpredict.oz9aec.net"
SRC_URI="https://github.com/csete/gpredict/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	x11-libs/gdk-pixbuf[jpeg]
	x11-libs/gtk+:3
	x11-libs/goocanvas:2.0
	net-misc/curl"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

src_prepare() {
	eapply_user
	# remove wrong doc location
	eapply "${FILESDIR}/${P}-doc.patch"
	eapply "${FILESDIR}/${PN}-2.2.1-fno-common.patch"
	eapply "${FILESDIR}/${PN}-2.3-gethostbyname.patch"

	eautoreconf
}
