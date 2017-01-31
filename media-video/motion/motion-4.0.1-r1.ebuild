# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools readme.gentoo-r1 user systemd

DESCRIPTION="A software motion detector"
HOMEPAGE="https://motion-project.github.io"
SRC_URI="https://github.com/Motion-Project/${PN}/archive/release-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="ffmpeg libav mmal mysql postgres v4l"

RDEPEND="
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	virtual/jpeg:=
	mmal? ( media-libs/raspberrypi-userland )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql:= )
"
DEPEND="${RDEPEND}
	v4l? ( virtual/os-headers media-libs/libv4l )
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You need to setup /etc/${PN}/${PN}.conf before running
${PN} for the first time. You can use /etc/${PN}/${PN}-dist.conf as a
template. Please note that the 'daemon' and 'process_id_file' settings
are overridden by the bundled OpenRC init script and systemd unit where
appropriate.

To install ${PN} as a service, use:
rc-update add ${PN} default # with OpenRC
systemctl enable ${PN}.service # with systemd
"

pkg_setup() {
	enewuser ${PN} -1 -1 -1 video
}

S="${WORKDIR}"/${PN}-release-${PV}

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_with ffmpeg) \
		$(use_with mmal) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		$(use_with v4l) \
		--without-optimizecpu
}

src_install() {
	emake \
		DESTDIR="${D}" \
		docdir=/usr/share/doc/${PF} \
		examplesdir=/usr/share/doc/${PF}/examples \
		install

	newinitd "${FILESDIR}"/${PN}.initd-r3 ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	systemd_dounit "${FILESDIR}"/${PN}.service
	systemd_dounit "${FILESDIR}"/${PN}_at.service
	systemd_dotmpfilesd "${FILESDIR}"/${PN}.conf

	keepdir /var/lib/motion
	fowners motion:video /var/lib/motion
	fperms 0750 /var/lib/motion

	readme.gentoo_create_doc
}
