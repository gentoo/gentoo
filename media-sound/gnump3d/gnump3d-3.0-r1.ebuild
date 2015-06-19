# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/gnump3d/gnump3d-3.0-r1.ebuild,v 1.6 2012/06/09 23:08:40 zmedico Exp $

inherit eutils multilib user

DESCRIPTION="A streaming server for MP3, OGG vorbis and other streamable files"
HOMEPAGE="http://www.gnu.org/software/gnump3d/"
SRC_URI="http://savannah.gnu.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ppc ppc64 sparc x86"
IUSE="sox"

RDEPEND="dev-lang/perl
	sox? ( media-sound/sox )"
DEPEND="dev-lang/perl
	sys-apps/sed"

RESTRICT="test"

pkg_setup() {
	enewuser gnump3d '' '' '' nogroup
	LIBDIR=/usr/$(get_libdir)
}

src_compile() { :; }

src_install() {
	PERLDIR="`perl bin/getlibdir`"

	insinto ${PERLDIR}/gnump3d
	doins lib/gnump3d/*.pm
	insinto ${PERLDIR}/gnump3d/plugins
	doins lib/gnump3d/plugins/*.pm
	insinto ${PERLDIR}/gnump3d/lang
	doins lib/gnump3d/lang/*.pm

	dobin bin/gnump3d2 bin/gnump3d-top bin/gnump3d-index
	dosym /usr/bin/gnump3d2 /usr/bin/gnump3d
	doman man/*.1

	insinto /usr/share/gnump3d
	doins -r templates/*

	insinto /etc/gnump3d
	doins etc/gnump3d.conf etc/mime.types etc/file.types
	dosed "s,PLUGINDIR,${PERLDIR},g" /etc/gnump3d/gnump3d.conf
	dosed 's,^user *= *\(.*\)$,user = gnump3d,g' /etc/gnump3d/gnump3d.conf

	dodoc AUTHORS ChangeLog DOWNSAMPLING PLUGINS README SUPPORT TODO

	newinitd "${FILESDIR}"/${PN}.init.d gnump3d
	newconfd "${FILESDIR}"/${PN}.conf.d gnump3d

	keepdir /var/log/gnump3d
	keepdir /var/cache/gnump3d/serving

	fowners gnump3d:nogroup /var/log/gnump3d /var/cache/gnump3d
}

pkg_postinst() {
	elog "Please edit your /etc/gnump3d/gnump3d.conf before running"
	elog "/etc/init.d/gnump3d start"
	elog ""
	elog "At the very least, you will need to change the root directory"
	elog "where music is found.  By default, gnump3d will also listen"
	elog "to any address on port 8888"
	elog ""
	elog "You can optionally use sox to downmix the quality of streamed"
	elog "music in realtime for slow connections."
}
