# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools readme.gentoo-r1 systemd

DESCRIPTION="A software motion detector"
HOMEPAGE="https://motion-project.github.io"
SRC_URI="https://github.com/Motion-Project/${PN}/archive/release-${PV}.tar.gz -> ${PN}-release-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="ffmpeg mariadb mmal mysql postgres sqlite v4l webp"

RDEPEND="
	acct-group/motion
	acct-user/motion
	net-libs/libmicrohttpd:=
	virtual/jpeg:=
	ffmpeg? ( media-video/ffmpeg:0= )
	mariadb? ( dev-db/mariadb-connector-c )
	mmal? ( media-libs/raspberrypi-userland )
	mysql? ( dev-db/mysql-connector-c )
	postgres? ( dev-db/postgresql:= )
	sqlite? ( dev-db/sqlite:3 )
	webp? ( media-libs/libwebp:= )
"
DEPEND="${RDEPEND}
	v4l? (
		media-libs/libv4l
		virtual/os-headers
	)
"

# Breaks src_install(), #727056
RESTRICT="test"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
You need to setup a configuraton file (/etc/motion/motion.conf) before
running motion for the first time.

If motion is built with the mysql or mariadb use flags then please make
sure to configure a matching database_type in the config file.

Motion runs by default under user motion and group motion:
- change this if needed in /etc/conf.d/motion
- or add users who need access to the output files to the motion group

To install motion as a service, use:
- rc-update add motion default # with OpenRC
- systemctl enable motion.service # with systemd
"

S="${WORKDIR}"/${PN}-release-${PV}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ffmpeg) \
		$(use_with mariadb) \
		$(use_with mmal) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with sqlite sqlite3) \
		$(use_with v4l v4l2) \
		$(use_with webp) \
		--without-optimizecpu
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		examplesdir=/usr/share/doc/${PF}/examples \
		install

	newinitd "${FILESDIR}/motion.initd-r5" ${PN}
	newconfd "${FILESDIR}/motion.confd-r5" ${PN}
	systemd_newunit "${FILESDIR}/${PN}.service-r4" "${PN}.service"
	readme.gentoo_create_doc
	readme.gentoo_print_elog
}
