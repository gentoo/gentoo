# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools eapi9-ver flag-o-matic systemd

DESCRIPTION="Opensource alternative to shoutcast that supports mp3, ogg and aac streaming"
HOMEPAGE="https://www.icecast.org/"
SRC_URI="https://downloads.xiph.org/releases/icecast/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="geoip +speex selinux +ssl test +theora +yp"
# TODO: few tests fail
RESTRICT="test"

#Although there is a --with-ogg and --with-vorbis configure option, they're
#only useful for specifying paths, not for disabling.
DEPEND="
	acct-group/icecast
	acct-user/icecast
	app-crypt/rhash:=
	>=dev-libs/libigloo-0.9.5
	dev-libs/libxml2:=
	dev-libs/libxslt
	media-libs/libogg
	media-libs/libvorbis
	virtual/libcrypt:=
	geoip? ( >=dev-libs/libmaxminddb-1.3.2:= )
	speex? ( media-libs/speex )
	ssl? ( dev-libs/openssl:0= )
	theora? ( media-libs/libtheora:= )
	yp? ( net-misc/curl )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-icecast )
"
BDEPEND="
	virtual/pkgconfig
	test? ( media-video/ffmpeg )
"

src_prepare() {
	default

	# fix clang
	eautoconf
}

src_configure() {
	# lto-mismatch, see libigloo
	filter-lto

	local myeconfargs=(
		--localstatedir="${EPREFIX}/var"
		--sysconfdir=/etc/icecast2
		$(use_with geoip maxminddb)
		$(use_with speex)
		$(use_with ssl openssl)
		$(use_with theora)
		$(use_enable yp)
		$(use_with yp curl)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	emake -j1 check
}

src_install() {
	local HTML_DOCS=( doc/. )

	default

	dodoc conf/*.xml.dist
	# clean doc
	find "${ED}"/usr/share/doc/${PF} -name "Makefile*" -delete || die
	rm -r "${ED}"/usr/share/doc/icecast || die
	rm -r "${ED}"/usr/share/icecast/doc || die

	newinitd "${FILESDIR}"/${PN}.initd-r1 ${PN}
	systemd_newunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	insinto /etc/icecast2
	insopts -m0640 -g icecast
	newins conf/icecast_minimal.xml.dist icecast.xml

	dodir /etc/logrotate.d
	insopts -m0644
	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${PN}.logrotate-r1 ${PN}.logrotate

	diropts -m0764 -o icecast -g icecast
	dodir /var/log/icecast
	keepdir /var/log/icecast
}

pkg_postinst() {
	if ver_replacing -lt 2.5.0; then
		ewarn "Daemon is now launched with unprivileged icecast:icecast by OpenRC/systemd."
		ewarn "To prevent permission conflicts, please check existing files/dir:"
		ewarn "    ${EROOT}/etc/icecast2/icecast.xml"
		ewarn "    ${EROOT}/var/log/icecast"
	fi
}
