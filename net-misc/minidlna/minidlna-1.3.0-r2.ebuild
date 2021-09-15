# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd tmpfiles

DESCRIPTION="DLNA/UPnP-AV compliant media server"
HOMEPAGE="https://sourceforge.net/projects/minidlna/"
SRC_URI="
	https://downloads.sourceforge.net/project/minidlna/${PN}/${PV}/${P}.tar.gz
	mirror://gentoo/minidlna-gentoo-artwork.patch.xz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="elibc_musl netgear readynas zeroconf"

RDEPEND="
	acct-group/minidlna
	acct-user/minidlna
	dev-db/sqlite:3
	media-libs/flac
	media-libs/libexif
	media-libs/libid3tag:=
	media-libs/libogg
	media-libs/libvorbis
	media-video/ffmpeg:0=
	virtual/jpeg:0=
	elibc_musl? ( sys-libs/queue-standalone )
	zeroconf? ( net-dns/avahi )"
DEPEND=${RDEPEND}
BDEPEND="
	virtual/pkgconfig"

CONFIG_CHECK="~INOTIFY_USER"

PATCHES=(
	"${WORKDIR}"/minidlna-gentoo-artwork.patch
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-fd-leak.patch
)

src_prepare() {
	sed -e "/log_dir/s:/var/log:/var/log/minidlna:" \
		-e "/db_dir/s:/var/cache/:/var/lib/:" \
		-i minidlna.conf || die

	default
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
