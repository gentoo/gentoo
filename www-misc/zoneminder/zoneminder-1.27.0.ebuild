# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TO DO:
# * ffmpeg support can be disabled in CMakeLists.txt but it does not build then
#		$(cmake-utils_useno ffmpeg ZM_NO_FFMPEG)
# * dependencies of unknown status:
# 	dev-perl/Archive-Zip
# 	dev-perl/Device-SerialPort
# 	dev-perl/MIME-Lite
# 	dev-perl/MIME-tools
# 	dev-perl/PHP-Serialization
# 	virtual/perl-Archive-Tar
# 	virtual/perl-libnet
# 	virtual/perl-Module-Load

EAPI=5

PERL_EXPORT_PHASE_FUNCTIONS=no

inherit perl-module readme.gentoo eutils base cmake-utils depend.apache multilib flag-o-matic

MY_PN="ZoneMinder"

DESCRIPTION="ZoneMinder allows you to capture, analyse, record and monitor any cameras attached to your system"
HOMEPAGE="http://www.zoneminder.com/"
SRC_URI="https://github.com/${MY_PN}/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="curl gcrypt gnutls +mmap +openssl vlc"
SLOT="0"

REQUIRED_USE="
	|| ( openssl gnutls )
"

DEPEND="
	dev-lang/perl:=
	dev-libs/libpcre
	dev-perl/Date-Manip
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/libwww-perl
	sys-libs/zlib
	virtual/ffmpeg
	virtual/httpd-php
	virtual/jpeg
	virtual/mysql
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Getopt-Long
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	curl? ( net-misc/curl )
	gcrypt? ( dev-libs/libgcrypt )
	gnutls? ( net-libs/gnutls )
	mmap? ( dev-perl/Sys-Mmap )
	openssl? ( dev-libs/openssl )
	vlc? ( media-video/vlc )
"
RDEPEND="${DEPEND}"

# we cannot use need_httpd_cgi here, since we need to setup permissions for the
# webserver in global scope (/etc/zm.conf etc), so we hardcode apache here.
need_apache

S=${WORKDIR}/${MY_PN}-${PV}

PATCHES=(
	"${FILESDIR}/${PN}-1.26.5"-automagic.patch
)

MY_ZM_WEBDIR=/usr/share/zoneminder/www

pkg_setup() {
	:
}

src_configure() {
	append-cxxflags -D__STDC_CONSTANT_MACROS
	perl_set_version

	mycmakeargs=(
		-DZM_PERL_SUBPREFIX=${VENDOR_LIB}
		-DZM_TMPDIR=/var/tmp/zm
		-DZM_WEB_USER=apache
		-DZM_WEB_GROUP=apache
		-DZM_WEBDIR=${MY_ZM_WEBDIR}
		$(cmake-utils_useno mmap ZM_NO_MMAP)
		-DZM_NO_X10=OFF
		-DZM_NO_FFMPEG=OFF
		$(cmake-utils_useno curl ZM_NO_CURL)
		$(cmake-utils_useno vlc ZM_NO_LIBVLC)
		$(cmake-utils_useno openssl CMAKE_DISABLE_FIND_PACKAGE_OpenSSL)
		$(cmake-utils_use_has gnutls)
		$(cmake-utils_use_has gcrypt)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# the log directory
	keepdir /var/log/zm
	fowners apache:apache /var/log/zm

	# now we duplicate the work of zmlinkcontent.sh
	dodir /var/lib/zoneminder /var/lib/zoneminder/images /var/lib/zoneminder/events
	fperms -R 0775 /var/lib/zoneminder
	fowners -R apache:apache /var/lib/zoneminder
	dosym /var/lib/zoneminder/images ${MY_ZM_WEBDIR}/images
	dosym /var/lib/zoneminder/events ${MY_ZM_WEBDIR}/events

	# the configuration file
	fperms 0640 /etc/zm.conf
	fowners root:apache /etc/zm.conf

	# init scripts etc
	newinitd "${FILESDIR}"/init.d zoneminder
	newconfd "${FILESDIR}"/conf.d zoneminder

	cp "${FILESDIR}"/10_zoneminder.conf "${T}"/10_zoneminder.conf
	sed -i "${T}"/10_zoneminder.conf -e "s:%ZM_WEBDIR%:${MY_ZM_WEBDIR}:g"

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README.md TODO "${T}"/10_zoneminder.conf

	readme.gentoo_src_install
}
