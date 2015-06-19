# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/guacamole-server/guacamole-server-0.9.2.ebuild,v 1.1 2014/08/12 09:05:32 nativemad Exp $

EAPI=5

inherit eutils
DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="http://guac-dev.org/"
SRC_URI="mirror://sourceforge/guacamole/${P}.tar.gz"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="rdesktop vnc ssh pulseaudio vorbis telnet"

DEPEND="x11-libs/cairo
	dev-libs/ossp-uuid
	ssh? ( x11-libs/pango
		net-libs/libssh2 )
	rdesktop? ( >=net-misc/freerdp-1.1.0_beta1_p20130710 )
	vnc? ( net-libs/libvncserver
	pulseaudio? ( media-sound/pulseaudio ) )
	vorbis? ( media-libs/libvorbis )
	telnet?	( net-libs/libtelnet )"

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
