# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils linux-info systemd toolchain-funcs user

DESCRIPTION="DLNA/UPnP-AV compliant media server"
HOMEPAGE="https://sourceforge.net/projects/minidlna/"
SRC_URI="mirror://sourceforge/minidlna/${PV}/${P}.tar.gz
	https://dev.gentoo.org/~xmw/minidlna-gentoo-artwork.patch.xz"

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

PATCHES=( "${WORKDIR}"/minidlna-gentoo-artwork.patch
	"${FILESDIR}"/${P}-buildsystem.patch )

src_prepare() {
	sed -e "/log_dir/s:/var/log:/var/log/minidlna:" \
		-e "/db_dir/s:/var/cache/:/var/lib/:" \
		-i minidlna.conf || die

	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-silent-rules \
		--with-db-path=/var/lib/minidlna \
		--with-log-path=/var/log/minidlna \
		--enable-tivo \
		$(use_enable avahi ) \
		$(use_enable netgear) \
		$(use_enable readynas)
}

src_install() {
	default

	#bug 536532
	dosym ../sbin/minidlnad /usr/bin/minidlna

	insinto /etc
	doins minidlna.conf

	newconfd "${FILESDIR}"/minidlna-1.0.25.confd minidlna
	newinitd "${FILESDIR}"/minidlna-1.1.5.initd minidlna
	systemd_newunit "${FILESDIR}"/minidlna-1.1.2.service minidlna.service
	echo "d /run/minidlna 0755 minidlna minidlna -" > "${T}"/minidlna.conf
	systemd_dotmpfilesd "${T}"/minidlna.conf

	keepdir /var/{lib,log}/minidlna

	dodoc AUTHORS NEWS README TODO
	doman minidlnad.8 minidlna.conf.5
}

pkg_preinst() {
	local my_is_new="yes"
	[ -d "${EPREFIX}"/var/lib/minidlna ] && my_is_new="no"

	enewgroup minidlna
	enewuser minidlna -1 -1 /var/lib/minidlna minidlna

	fowners minidlna:minidlna /var/{lib,log}/minidlna
	fperms 0750 /var/{lib,log}/minidlna

	if [ -d "${EPREFIX}"/var/lib/minidlna ] && [ "${my_is_new}" == "yes" ] ; then
		# created by above enewuser command w/ wrong group and permissions
		chown minidlna:minidlna "${EPREFIX}"/var/lib/minidlna || die
		chmod 0750 "${EPREFIX}"/var/lib/minidlna || die
		# if user already exists, but /var/lib/minidlna is missing
		# rely on ${D}/var/lib/minidlna created in src_install
	fi
}

pkg_postinst() {
	elog "minidlna now runs as minidlna:minidlna (bug 426726),"
	elog "logfile is moved to /var/log/minidlna/minidlna.log,"
	elog "cache is moved to /var/lib/minidlna."
	elog "Please edit /etc/conf.d/minidlna and file ownerships to suit your needs."
}
