# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

VERSION="718" # every bump, new version

DESCRIPTION="WWW Admin for the VDR (Video Disk Recorder)"
HOMEPAGE="https://projects.vdr-developer.org/projects/xxv"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz
		mirror://gentoo/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="-mplayer themes"

RDEPEND=">=media-video/vdr-1.2.6
	media-video/vdr2jpeg
	media-fonts/corefonts
	virtual/mysql
	dev-perl/CGI
	virtual/perl-Digest-MD5
	virtual/perl-Getopt-Long
	virtual/perl-MIME-Base64
	virtual/perl-Time-HiRes
	virtual/perl-IO-Compress
	dev-perl/Config-Tiny
	dev-perl/Date-Manip
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/Digest-HMAC
	dev-perl/Encode-Detect
	dev-perl/Event
	dev-perl/Font-TTF
	dev-perl/GD[png,gif]
	dev-perl/IO-Socket-INET6
	dev-perl/JSON
	dev-perl/JSON-XS
	dev-perl/Linux-Inotify2
	dev-perl/Locale-gettext
	dev-perl/MP3-Info
	dev-perl/Net-Amazon
	dev-perl/Net-Telnet
	dev-perl/Net-XMPP
	dev-perl/Proc-ProcessTable
	dev-perl/SOAP-Lite
	dev-perl/txt2html
	dev-perl/Template-GD
	dev-perl/Template-Toolkit
	dev-perl/XML-RSS
	themes? ( >=x11-themes/${PN}-skins-1.6 )"

PDEPEND="mplayer? ( media-video/mplayer )"

SHAREDIR="/usr/share/${PN}"
LIBDIR="/usr/lib/${PN}"

DB_VERS="32"

db_update_check() {

	DB_VERS_OLD="`cat /var/db/pkg/www-misc/xxv-*/xxv-*.ebuild | grep DB_VERS | head -n 1 | cut -c10-11`"

	if [ "${DB_VERS_OLD}" -lt "${DB_VERS}" ]; then
		echo
		elog "An update of the XXV Database is necessary !!!"
		echo
		elog "\tcd ${SHAREDIR}/contrib"
		echo
		elog "\tIt is really important to edit the create-database.sql file first"
		elog "\tdue to UTF-8 Support changes in the MySQL DB !!!"
		echo
		elog "\tafter this run ./update-xxv -h for more info"
		echo
	else
		echo
		elog "If this is a new install"
		elog "You have to create an empty DB for XXV"
		echo
		elog "do this by:"
		elog "cd ${SHAREDIR}/contrib"
		eerror "read the README"
		elog "For UTF-8 support it is really important to"
		elog "edit create-database.sql file first and run"
		elog "emerge --config ${PN}"
		elog "afterwards"
		echo
		elog "Set your own language in"
		elog "${SHAREDIR}/locale"
		echo
		elog "The default user/password is:"
		elog "User/Password: xxv:xxv"
		elog "You should change it immediately!"
		echo
		eerror "edit /etc/xxv/xxvd.cfg !"
	fi
}

pkg_setup() {

	if ! has_version "www-misc/${PN}"; then
		echo
		einfo	"After you install xxv the very first time you should consider to read"
		einfo	"http://www.vdr-wiki.de/wiki/index.php/Xxv (German only)"
		echo
	fi

	db_update_check
}

src_prepare() {

	sed -i "${S}"/bin/xxvd \
		-e "s:debian:Gentoo:" \
		-e "s:/var/log/xxvd.log:/var/log/xxv/xxvd.log:" \
		-e "s:/var/run/xxvd.pid:/var/run/xxv/xxvd.pid:" \
		-e "s:\$RealBin/../lib:${LIBDIR}:" \
		-e "s:\$RealBin/../locale:${SHAREDIR}/locale:" \
		-e "s:\$RealBin/../lib/XXV/MODULES:${LIBDIR}/XXV/MODULES:" \
		-e "s:\$RealBin/../etc/xxvd.cfg:/etc/xxv/xxvd.cfg:" \
		-e "s:\$RealBin/../doc:/usr/share/doc/${P}:" \
		-e "s:HTMLDIR     => \"\$RealBin/../:HTMLDIR     => \"${SHAREDIR}/skins:" \
		-e "s:\$RealBin/../share/vtx:${SHAREDIR}/vtx:" \
		-e "s:\$Real	Bin/../lib/XXV/OUTPUT:${LIBDIR}/XXV/OUTPUT:" \
		-e "s:\$RealBin/../share/news:${SHAREDIR}/news:" \
		-e "s:\$RealBin/../contrib:${SHAREDIR}/contrib:" \
		-e "s:\$RealBin/../share/fonts/ttf-bitstream-vera:/usr/share/fonts/corefonts:" \
		-e "s:\$RealBin/../share/xmltv:${SHAREDIR}/xmltv:"

	sed -i "s:\$RealBin/../lib:${LIBDIR}:" ./locale/xgettext.pl
}

src_install() {

	newinitd "${FILESDIR}"/xxv.utf8-v5 xxv

	dobin	bin/xxvd

	insinto /etc/"${PN}"
	newins "${FILESDIR}"/xxvd-1.0.cfg xxvd.cfg
	chown vdr:vdr "${D}"/etc/"${PN}"/xxvd.cfg

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/xxvd-logrotate xxvd

	diropts -m755 -ovdr -gvdr
	keepdir /var/cache/xxv
	keepdir /var/run/xxv
	keepdir /var/log/xxv

	insinto "${LIBDIR}"
	doins -r "${S}"/lib/*

	insinto "${SHAREDIR}"
	doins -r "${S}"/share/{news,xmltv}

	insinto "${SHAREDIR}"/locale
	doins -r "${S}"/locale/*
	fperms 0755 "${SHAREDIR}"/locale/xgettext.pl

	insinto "${SHAREDIR}"/contrib
	doins -r "${S}"/contrib/*
	fperms 0755 "${SHAREDIR}"/contrib/update-xxv

	insinto "${SHAREDIR}"/skins
	doins -r "${S}"/{html,wml}
	doins "${S}"/doc/docu.tmpl

	cd "${S}"/doc
	insinto /usr/share/doc/"${P}"
	doins docu.tmpl CHANGELOG README
	fowners vdr:vdr /usr/share/doc/"${P}"

	doman xxvd.1
}

pkg_config() {

		cd "${ROOT}"/"${SHAREDIR}"
		cat ./contrib/create-database.sql | mysql -u root -p
}

pkg_postrm() {

	einfo "Cleanup for old "${P}" files"
	rm -r /usr/share/doc/"${P}"
}
