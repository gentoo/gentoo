# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Streaming server for MP3, OGG vorbis and other streamable files"
HOMEPAGE="https://www.gnu.org/software/gnump3d/"
SRC_URI="https://savannah.gnu.org/download/${PN}/${P}.tar.bz2"

LICENSE="GPL-2+ || ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ppc64 sparc x86"
IUSE="sox"

DEPEND="
	acct-group/gnump3d
	acct-user/gnump3d
"

RDEPEND="
	${DEPEND}
	sox? ( media-sound/sox )
"

RESTRICT="test"

pkg_setup() {
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
	dosym gnump3d2 /usr/bin/gnump3d
	doman man/*.1

	insinto /usr/share/gnump3d
	doins -r templates/*

	insinto /etc/gnump3d
	doins etc/gnump3d.conf etc/mime.types etc/file.types
	sed -e "s,PLUGINDIR,${VENDOR_LIB},g" -i "${ED}/etc/gnump3d/gnump3d.conf" || die
	sed -e 's,^user *= *\(.*\)$,user = gnump3d,g' -i "${ED}/etc/gnump3d/gnump3d.conf" || die

	dodoc AUTHORS ChangeLog DOWNSAMPLING PLUGINS README SUPPORT TODO

	newinitd "${FILESDIR}"/${PN}.init.d-r1 gnump3d
	newconfd "${FILESDIR}"/${PN}.conf.d gnump3d

	keepdir /var/log/gnump3d
	fowners gnump3d:gnump3d /var/log/gnump3d
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
