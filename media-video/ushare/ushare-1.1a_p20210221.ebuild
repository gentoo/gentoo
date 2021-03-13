# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1 toolchain-funcs systemd

COMMIT="79b0d6e41fd9af73c2ef7ee6b110f9b367295a76"

DESCRIPTION="uShare is a UPnP (TM) A/V & DLNA Media Server"
HOMEPAGE="https://github.com/ddugovic/uShare/"
SRC_URI="https://github.com/ddugovic/uShare/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

DEPEND=">=net-libs/libupnp-1.14"
RDEPEND="acct-user/ushare
	${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/01_all_ushare_build_system.patch
	"${FILESDIR}"/02_all_ushare_build_warnings.patch
	"${FILESDIR}"/03_all_ushare_mp4_video_mime.patch
	"${FILESDIR}"/07_all_drop_optimizations.patch
)
DOCS="NEWS README.md TODO THANKS AUTHORS"
DOC_CONTENTS="Please edit /etc/ushare.conf to set the shared directories
	and other important settings. Check system log if ushare is
	not booting."

S="${WORKDIR}/uShare-${COMMIT}"

src_configure() {
	local myconf
	myconf="--prefix=/usr --sysconfdir=/etc --disable-strip --disable-dlna"
	# nls can only be disabled, on by default.
	use nls || myconf="${myconf} --disable-nls"

	# I can't use econf
	# --host is not implemented in ./configure file
	tc-export CC CXX

	./configure ${myconf} || die "./configure failed"
}

src_install() {
	default
	doman src/ushare.1
	newconfd "${FILESDIR}"/${PN}.conf.d ${PN}
	newinitd "${FILESDIR}"/${PN}.init.d.ng ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
	elog
	elog "The config file has been moved to /etc/ushare.conf"
	elog "Please migrate your settings from /etc/conf.d/ushare"
	elog "to /etc/ushare.conf in order to use the ushare init script"
	elog "and systemd unit service."
	elog
}
