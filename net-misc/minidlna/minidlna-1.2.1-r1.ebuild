# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils linux-info systemd toolchain-funcs user

DESCRIPTION="DLNA/UPnP-AV compliant media server"
HOMEPAGE="https://sourceforge.net/projects/minidlna/"
SRC_URI="mirror://sourceforge/${PN}/${PV}/${P}.tar.gz
	https://dev.gentoo.org/~xmw/${PN}-gentoo-artwork.patch.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="avahi libav netgear readynas"

RDEPEND="dev-db/sqlite:3
	media-libs/flac:=
	media-libs/libexif:=
	media-libs/libid3tag:=
	media-libs/libogg:=
	media-libs/libvorbis:=
	virtual/jpeg:0=
	avahi? ( net-dns/avahi )
	libav? ( media-video/libav:0= )
	!libav? ( media-video/ffmpeg:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~INOTIFY_USER"

PATCHES=( "${WORKDIR}"/${PN}-gentoo-artwork.patch
	"${FILESDIR}"/${P}-buildsystem.patch )

src_prepare() {
	sed -e "/log_dir/s:/var/log:/var/log/${PN}:" \
		-e "/db_dir/s:/var/cache/:/var/lib/:" \
		-i ${PN}.conf || die

	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		--with-db-path=/var/lib/${PN} \
		--with-log-path=/var/log/${PN} \
		--enable-tivo \
		$(use_enable avahi ) \
		$(use_enable netgear) \
		$(use_enable readynas)
}

src_install() {
	default

	#bug 536532
	dosym /usr/sbin/${PN}d /usr/bin/${PN}

	insinto /etc
	doins ${PN}.conf

	newconfd "${FILESDIR}"/${PN}-1.0.25.confd ${PN}
	newinitd "${FILESDIR}"/${PN}-1.1.5.initd ${PN}
	systemd_newunit "${FILESDIR}"/${PN}-1.1.2.service ${PN}.service
	echo "d /run/${PN} 0755 ${PN} ${PN} -" > "${T}"/${PN}.conf
	systemd_dotmpfilesd "${T}"/${PN}.conf

	keepdir /var/{lib,log}/${PN}

	dodoc AUTHORS NEWS README TODO
	doman ${PN}d.8 ${PN}.conf.5
}

pkg_preinst() {
	local my_is_new="yes"
	[ -d "${EPREFIX}"/var/lib/${PN} ] && my_is_new="no"

	enewgroup ${PN}
	enewuser ${PN} -1 -1 /var/lib/${PN} ${PN}

	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	fperms 0750 /var/{lib,log}/${PN}

	if [ -d "${EPREFIX}"/var/lib/${PN} ] && [ "${my_is_new}" == "yes" ] ; then
		# created by above enewuser command w/ wrong group and permissions
		chown ${PN}:${PN} "${EPREFIX}"/var/lib/${PN} || die
		chmod 0750 "${EPREFIX}"/var/lib/${PN} || die
		# if user already exists, but /var/lib/minidlna is missing
		# rely on ${D}/var/lib/minidlna created in src_install
	fi
}

pkg_postinst() {
	elog "minidlna now runs as minidlna:minidlna (bug 426726),"
	elog "logfile is moved to /var/log/minidlna/minidlna.log,"
	elog "cache is moved to /var/lib/minidlna."
	elog "Please edit /etc/conf.d/${PN} and file ownerships to suit your needs."
}
