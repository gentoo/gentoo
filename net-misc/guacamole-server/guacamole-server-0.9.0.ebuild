# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/guacamole-server/guacamole-server-0.9.0.ebuild,v 1.4 2014/08/10 20:44:12 slyfox Exp $

EAPI=5

inherit eutils
DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="http://guacamole.sourceforge.net/"
SRC_URI="mirror://sourceforge/guacamole/${P}.tar.gz"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="rdesktop vnc ssh pulseaudio vorbis"

DEPEND="x11-libs/cairo
	ssh? ( x11-libs/pango
		net-libs/libssh2 )
	rdesktop? ( >=net-misc/freerdp-1.1.0_beta1_p20130710 )
	vnc? ( net-libs/libvncserver
	pulseaudio? ( media-sound/pulseaudio ) )
	vorbis? ( media-libs/libvorbis )"

RDEPEND="${DEPEND}"

src_configure() {
	econf --with-init-dir=/etc/init.d
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
