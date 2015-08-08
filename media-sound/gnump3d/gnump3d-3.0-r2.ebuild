# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no
inherit eutils multilib user perl-module

DESCRIPTION="A streaming server for MP3, OGG vorbis and other streamable files"
HOMEPAGE="http://www.gnu.org/software/gnump3d/"
SRC_URI="http://savannah.gnu.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="sox"

RDEPEND="sox? ( media-sound/sox )"
DEPEND="sys-apps/sed"

RESTRICT="test"

pkg_setup() {
	enewuser gnump3d '' '' '' nogroup
	LIBDIR=/usr/$(get_libdir)
}

src_compile() { :; }

src_install() {
	perl_set_version

	insinto "${VENDOR_LIB}"/gnump3d
	doins lib/gnump3d/*.pm
	insinto "${VENDOR_LIB}"/gnump3d/plugins
	doins lib/gnump3d/plugins/*.pm
	insinto "${VENDOR_LIB}"/gnump3d/lang
	doins lib/gnump3d/lang/*.pm

	dobin bin/gnump3d2 bin/gnump3d-top bin/gnump3d-index
	dosym /usr/bin/gnump3d2 /usr/bin/gnump3d
	doman man/*.1

	insinto /usr/share/gnump3d
	doins -r templates/*

	insinto /etc/gnump3d
	doins etc/gnump3d.conf etc/mime.types etc/file.types
	sed -e "s,PLUGINDIR,${VENDOR_LIB},g" -i "${ED}/etc/gnump3d/gnump3d.conf" || die
	sed -e 's,^user *= *\(.*\)$,user = gnump3d,g' -i "${ED}/etc/gnump3d/gnump3d.conf" || die

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
