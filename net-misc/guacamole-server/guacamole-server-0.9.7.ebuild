# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/guacamole-server/guacamole-server-0.9.7.ebuild,v 1.1 2015/06/13 09:15:22 nativemad Exp $

EAPI=5

inherit eutils systemd user
DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="http://guac-dev.org/"
SRC_URI="mirror://sourceforge/guacamole/${P}.tar.gz"

LICENSE="MIT"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="rdesktop vnc ssh pulseaudio vorbis telnet ssl"

DEPEND="x11-libs/cairo
	media-libs/libpng:*
	dev-libs/ossp-uuid
	rdesktop? ( <net-misc/freerdp-1.1.0_beta1_p20150312 )
	ssh? ( x11-libs/pango
		net-libs/libssh2 )
	telnet?	( net-libs/libtelnet
		x11-libs/pango )
	vnc? ( net-libs/libvncserver
		pulseaudio? ( media-sound/pulseaudio ) )
	ssl? ( dev-libs/openssl:* )
	vorbis? ( media-libs/libvorbis )"

RDEPEND="${DEPEND}"

src_configure() {
	local myconf="--without-terminal --without-pango"
	if use ssh || use telnet; then
		myconf="--with-terminal --with-pango"
	fi

	econf $myconf \
		$(use_with ssh) \
		$(use_with rdesktop rdp) \
		$(use_with vnc) \
		$(use_with pulseaudio pulse) \
		$(use_with vorbis) \
		$(use_with telnet) \
		$(use_with ssl)
}

src_install() {
	emake DESTDIR="${D}" install

	doinitd "${FILESDIR}/guacd"
	systemd_dounit "${FILESDIR}/guacd.service"
}

pkg_postinst() {
	enewgroup guacd
	enewuser guacd -1 -1 -1 guacd
}
