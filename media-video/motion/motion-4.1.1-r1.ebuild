# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools readme.gentoo-r1 systemd user

DESCRIPTION="A software motion detector"
HOMEPAGE="https://motion-project.github.io"
SRC_URI="https://github.com/Motion-Project/${PN}/archive/release-${PV}.tar.gz -> ${PN}-release-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="ffmpeg libav mmal mysql postgres sqlite v4l webp"

RDEPEND="
	virtual/jpeg:=
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	mmal? ( media-libs/raspberrypi-userland )
	mysql? ( virtual/mysql )
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

PATCHES=(
	"${FILESDIR}"/${PV}/Fix-build-errors-with-FFmpeg-4.0.patch
)

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
You need to setup /etc/motion/motion.conf before running motion for the
first time. You can use /etc/motion/motion-dist.conf as a template.
Please note that the 'daemon' and 'process_id_file' settings are
overridden by the bundled OpenRC init script and systemd unit where
appropriate.

To install motion as a service, use:
rc-update add motion default # with OpenRC
systemctl enable motion.service # with systemd
"

S="${WORKDIR}"/${PN}-release-${PV}

pkg_setup() {
	enewuser ${PN} -1 -1 -1 video
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ffmpeg) \
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

	newinitd "${FILESDIR}"/${PN}.initd-r3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd-r1 ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}.conf

	keepdir /var/lib/motion
	fowners motion:video /var/lib/motion
	fperms 0750 /var/lib/motion

	readme.gentoo_create_doc
	readme.gentoo_print_elog
}
