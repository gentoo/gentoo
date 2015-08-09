# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils
DESCRIPTION="This is the proxy-daemon used by www-apps/guacamole"

HOMEPAGE="http://guac-dev.org/"
SRC_URI="mirror://sourceforge/guacamole/${P}.tar.gz"

LICENSE="AGPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE="rdesktop vnc ssh pulseaudio vorbis telnet pango terminal ssl"

DEPEND="x11-libs/cairo
	dev-libs/ossp-uuid
	ssh? ( x11-libs/pango
		net-libs/libssh2 )
	rdesktop? ( >=net-misc/freerdp-1.1.0_beta1_p20130710
		<net-misc/freerdp-9999 )
	vnc? ( net-libs/libvncserver
	pulseaudio? ( media-sound/pulseaudio ) )
	vorbis? ( media-libs/libvorbis )
	telnet?	( net-libs/libtelnet )
	pango?	( x11-libs/pango )
	ssl? ( dev-libs/openssl )"

RDEPEND="${DEPEND}"

src_configure() {
	econf --with-init-dir=/etc/init.d \
	$(use ssh && echo "--with-ssh" || echo "--without-ssh") \
	$(use rdesktop && echo "--with-rdp" || echo "--without-rdp") \
	$(use vnc && echo "--with-vnc" || echo "--without-vnc") \
	$(use pulseaudio && echo "--with-pulse" || echo "--without-pulse") \
	$(use vorbis && echo "--with-vorbis" || echo "--without-vorbis") \
	$(use telnet && echo "--with-telnet" || echo "--without-telnet") \
	$(use pango && echo "--with-pango" || echo "--without-pango") \
	$(use terminal && echo "--with-terminal" || echo "--without-terminal")
	$(use ssl && echo "--with-ssl" || echo "--without-ssl")
}

src_compile() {
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
