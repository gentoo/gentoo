# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

VDR_CONF_DIR="/etc/vdr"
VDR_VIDEO_DIR="/var/vdr/video"

CONF_DIR="/etc/vdr/tvmovie2vdr"
VAR_DIR="/var/vdr/tvmovie2vdr"
SHARE_DIR="/usr/share/${PN}"

DESCRIPTION="load the program guide from tvmovie and others to vdr"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://steckrue.be/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

DEPEND=">=media-video/vdr-1.2.0
	>=dev-perl/Date-Manip-5.42a-r1
	>=virtual/perl-IO-Compress-1.22
	>=dev-perl/Archive-Zip-1.14
	>=dev-perl/Text-Iconv-1.4
	>=dev-perl/libwww-perl-5.69-r2
	>=dev-perl/HTML-Parser-3.34-r1
	>=dev-perl/HTML-Scrubber-0.08
	>=dev-perl/HTML-TableContentParser-0.13
	>=dev-perl/XML-Simple-DTDReader-0.03
	>=media-gfx/imagemagick-6.2.2.3
	dev-perl/Date-Manip
	dev-perl/XML-Simple-DTDReader"

src_compile() {
	# change default downloadpath in config
	sed -i config/config.pl_dist \
	  -e "s:channelsfile = .*;:channelsfile = \"${VDR_CONF_DIR}/channels.conf\";:" \
	  -e "s:epgfile = .*;:epgfile = \"${VDR_VIDEO_DIR}/epg.data\";:" \
	  -e "s:downloadprefix = .*;:downloadprefix = \"${VAR_DIR}/downloadfiles/\";:" \
	  -e "s:updateprefix = .*;:updateprefix = \"${VAR_DIR}/downloadupdatefiles/\";:" \
	  -e "s:infosaturl=.*;:infosaturl=\"${VAR_DIR}/infosatepg\";:" \
	  -e 's:imagepath = .*;:imagepath = "/var/vdr/epgimages";:'

	# set correct pathes to conf and include files
	sed -i tvm2vdr tvinfomerk2vdr clearoldtimer \
	  -e 's:push (@INC, "./config");:push (@INC, "'${CONF_DIR}'");:' \
	  -e 's:push (@INC, "./inc");:push (@INC, "'${SHARE_DIR}/inc'");:' \
	  -e "s:contrib/:${SHARE_DIR}/contrib/:"
}

src_install() {
	# config files
	insinto "${CONF_DIR}"
	local c
	for c in channels.pl channels_vps_wanted.pl	channels_wanted.pl config.pl; do
		newins "config/${c}_dist" "${c}"
	done

	# include files - helpers for different providers
	insinto "${SHARE_DIR}/inc"
	doins inc/*

	exeinto "${SHARE_DIR}/contrib"
	doexe ./contrib/*
	doexe clearoldtimer getinfosat tvm2vdr.sh

	# install main binaries
	dobin tvinfomerk2vdr
	dobin tvm2vdr

	# dirs to keep downloaded data in
	keepdir "${VAR_DIR}/downloadfiles"
	keepdir "${VAR_DIR}/downloadupdatefiles"
	keepdir "/var/vdr/epgimages"
	chown -R vdr:vdr "${D}/${VAR_DIR}" "${D}/var/vdr/epgimages"

	# install documentation
	dodoc HISTORY README tvm2vdr.sh
}

pkg_postinst() {
	# cleanup old cruft
	[ -L "${ROOT}/etc/vdr/tvmovie2vdr/files" ] \
		&& rm -f "${ROOT}/etc/vdr/tvmovie2vdr/files"

	[ -L "${ROOT}/var/vdr/tvmovie2vdr/tvmovie2vdr" ] \
		&& rm -f "${ROOT}/var/vdr/tvmovie2vdr/tvmovie2vdr"

	eerror "The executable name of tvmovie2vdr changed!"
	eerror "Old name was tvm2vdr.pl, new is: tvm2vdr"
	eerror "Please change name in your cron-job!"
	eerror

	elog "You have to configure the following files:"
	elog "\t${CONF_DIR}/config.pl"
	elog "\t${CONF_DIR}/channels_wanted.pl"
	elog
	elog "It's a good idea to add the following to /etc/crontab:"
	elog "\t3  5  * * *	   vdr	   /usr/bin/tvinfomerk2vdr"
	elog "\t7  5  * * *	   vdr	   /usr/bin/tvm2vdr"
	elog
	elog "To delete old pictures you should run the following command with the tvmovie2vdr run:"
	elog "\tfind /var/vdr/epgimages/ -type f -mtime +10 -exec rm {} \;"
	elog "or see tvm2vdr.sh in /usr/share/tvmovie2vdr/contrib"
	elog
}
