# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A small, fast, full-featured window manager for X"
HOMEPAGE="https://github.com/bbidulock/blackboxwm"
SRC_URI="https://github.com/bbidulock/blackboxwm/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls truetype debug"

RDEPEND="x11-libs/libXft
	x11-libs/libXt
	nls? ( >=sys-devel/gettext-0.20 )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"/blackboxwm-${PV}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir=/etc/X11/${PN} \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable truetype xft)
}

src_install() {
	dodir /etc/X11/Sessions
	echo "/usr/bin/blackbox" > "${D}/etc/X11/Sessions/${PN}"
	fperms a+x /etc/X11/Sessions/${PN}

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* COMPLIANCE README* TODO

	prune_libtool_files --all
}
