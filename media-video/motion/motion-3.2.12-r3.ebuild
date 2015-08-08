# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils readme.gentoo user

DESCRIPTION="A software motion detector"
HOMEPAGE="http://www.lavrsen.dk/twiki/bin/view/Motion/WebHome"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ppc x86"
IUSE="ffmpeg libav mysql postgres +v4l"

RDEPEND="
	sys-libs/zlib
	virtual/jpeg
	ffmpeg? (
		libav? ( media-video/libav:= )
		!libav? ( media-video/ffmpeg:0= )
	)
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
"
# note: libv4l is only in dependencies for the libv4l1-videodev.h header file
# used by the -workaround-v4l1_deprecation.patch.
DEPEND="${RDEPEND}
	v4l? ( virtual/os-headers media-libs/libv4l )
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="You need to setup /etc/motion.conf before running
motion for the first time.
You can install motion detection as a service, use:
rc-update add motion default
"

pkg_setup() {
	enewuser motion -1 -1 -1 video
}

src_prepare() {
	epatch \
		"${FILESDIR}"/ffmpeg-1.patch \
		"${FILESDIR}"/ffmpeg-2.patch \
		"${FILESDIR}"/ffmpeg-3.patch \
		"${FILESDIR}"/ffmpeg-4.patch \
		"${FILESDIR}"/ffmpeg-5.patch \
		"${FILESDIR}"/libav-9.patch \
		"${FILESDIR}"/${P}-workaround-v4l1_deprecation.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_with v4l) \
		$(use_with ffmpeg) \
		$(use_with mysql) \
		$(use_with postgres pgsql) \
		--without-optimizecpu
}

src_install() {
	emake \
		DESTDIR="${D}" \
		DOC='CHANGELOG CODE_STANDARD CREDITS FAQ README' \
		docdir=/usr/share/doc/${PF} \
		EXAMPLES='thread*.conf' \
		examplesdir=/usr/share/doc/${PF}/examples \
		install

	dohtml *.html

	newinitd "${FILESDIR}"/motion.initd-r2 motion
	newconfd "${FILESDIR}"/motion.confd motion

	mv -vf "${D}"/etc/motion{-dist,}.conf || die

	readme.gentoo_create_doc
}
