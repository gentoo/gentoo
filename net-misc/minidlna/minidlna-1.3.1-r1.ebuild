# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd tmpfiles

MY_P=${P//./_}
DESCRIPTION="DLNA/UPnP-AV compliant media server"
HOMEPAGE="https://sourceforge.net/projects/minidlna/"
#	https://downloads.sourceforge.net/project/minidlna/${PN}/${PV}/${P}.tar.gz
SRC_URI="
	https://github.com/mgorny/minidlna/archive/v${PV//./_}.tar.gz
		-> ${MY_P}.tar.gz
	mirror://gentoo/minidlna-gentoo-artwork.patch.xz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="netgear readynas zeroconf"

DEPEND="
	dev-db/sqlite:3
	media-libs/flac:=
	media-libs/libexif
	media-libs/libid3tag:=
	media-libs/libjpeg-turbo:=
	media-libs/libogg
	media-libs/libvorbis
	media-video/ffmpeg:=
	elibc_musl? ( sys-libs/queue-standalone )
	zeroconf? ( net-dns/avahi )
"
RDEPEND="
	${DEPEND}
	acct-group/minidlna
	acct-user/minidlna
"
BDEPEND="
	virtual/pkgconfig
"

CONFIG_CHECK="~INOTIFY_USER"

PATCHES=(
	"${WORKDIR}"/minidlna-gentoo-artwork.patch
)

src_prepare() {
	sed -e "/log_dir/s:/var/log:/var/log/minidlna:" \
		-e "/db_dir/s:/var/cache/:/var/lib/:" \
		-i minidlna.conf || die

	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-db-path=/var/lib/minidlna
		--with-log-path=/var/log/minidlna
		--enable-tivo
		$(use_enable netgear)
		$(use_enable readynas)
	)
	use zeroconf || myconf+=(
		ac_cv_lib_avahi_client_avahi_threaded_poll_new=no
	)

	econf "${myconf[@]}"
}

src_test() {
	:
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
	newtmpfiles - minidlna.conf <<-EOF
		d /run/minidlna 0755 minidlna minidlna -
	EOF

	keepdir /var/{lib,log}/minidlna

	doman minidlnad.8 minidlna.conf.5
}

pkg_preinst() {
	local my_is_new=yes
	[[ -d ${EROOT}/var/lib/minidlna ]] && my_is_new=no

	fowners minidlna:minidlna /var/{lib,log}/minidlna
	fperms 0750 /var/{lib,log}/minidlna
}

pkg_postinst() {
	tmpfiles_process minidlna.conf
}
