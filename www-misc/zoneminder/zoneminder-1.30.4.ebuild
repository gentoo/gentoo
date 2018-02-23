# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TO DO:
# * dependencies of unknown status:
#	dev-perl/Device-SerialPort
# 	dev-perl/MIME-Lite
# 	dev-perl/MIME-tools
# 	dev-perl/PHP-Serialization
# 	virtual/perl-Archive-Tar
# 	virtual/perl-libnet
# 	virtual/perl-Module-Load

EAPI=6

inherit versionator perl-functions readme.gentoo-r1 cmake-utils depend.apache flag-o-matic systemd

MY_PN="ZoneMinder"

MY_CRUD_VERSION="3.1.0"

DESCRIPTION="Capture, analyse, record and monitor any cameras attached to your system"
HOMEPAGE="http://www.zoneminder.com/"
SRC_URI="
	https://github.com/${MY_PN}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/FriendsOfCake/crud/archive/v${MY_CRUD_VERSION}.tar.gz -> Crud-${MY_CRUD_VERSION}.tar.gz
"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="curl ffmpeg gcrypt gnutls +mmap +ssl libressl vlc"
SLOT="0"

REQUIRED_USE="
	|| ( ssl gnutls )
"

DEPEND="
	app-eselect/eselect-php[apache2]
	dev-lang/perl:=
	dev-lang/php:*[apache2,cgi,curl,gd,inifile,pdo,mysql,mysqli,sockets]
	dev-libs/libpcre
	dev-perl/Archive-Zip
	dev-perl/Class-Std-Fast
	dev-perl/Data-Dump
	dev-perl/Date-Manip
	dev-perl/Data-UUID
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/IO-Socket-Multicast
	dev-perl/SOAP-WSDL
	dev-perl/Sys-CPU
	dev-perl/Sys-MemInfo
	dev-perl/URI-Encode
	dev-perl/libwww-perl
	dev-php/pecl-apcu:*
	sys-auth/polkit
	sys-libs/zlib
	virtual/ffmpeg
	virtual/httpd-php:*
	virtual/jpeg:0
	virtual/mysql
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Getopt-Long
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	www-servers/apache
	curl? ( net-misc/curl )
	gcrypt? ( dev-libs/libgcrypt:0= )
	gnutls? ( net-libs/gnutls )
	mmap? ( dev-perl/Sys-Mmap )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	vlc? ( media-video/vlc[live] )
"
RDEPEND="${DEPEND}"

# we cannot use need_httpd_cgi here, since we need to setup permissions for the
# webserver in global scope (/etc/zm.conf etc), so we hardcode apache here.
need_apache

PATCHES=(
	"${FILESDIR}/${PN}-1.30.2"-diskspace.patch
	"${FILESDIR}/${PN}-1.30.4"-path_zms.patch
	"${FILESDIR}/${PN}-1.30.4"-glibc226.patch
	"${FILESDIR}/${PN}-1.30.4"-gcc7.patch
)

MY_ZM_WEBDIR=/usr/share/zoneminder/www

src_prepare() {
	cmake-utils_src_prepare

	rmdir "${S}/web/api/app/Plugin/Crud" || die
	mv "${WORKDIR}/crud-${MY_CRUD_VERSION}" "${S}/web/api/app/Plugin/Crud" || die
}

src_configure() {
	append-cxxflags -D__STDC_CONSTANT_MACROS
	perl_set_version

	mycmakeargs=(
		-DZM_PERL_SUBPREFIX=${VENDOR_LIB#/usr}
		-DZM_TMPDIR=/var/tmp/zm
		-DZM_SOCKDIR=/var/run/zm
		-DZM_WEB_USER=apache
		-DZM_WEB_GROUP=apache
		-DZM_WEBDIR=${MY_ZM_WEBDIR}
		-DZM_NO_MMAP="$(usex mmap OFF ON)"
		-DZM_NO_X10=OFF
		-DZM_NO_FFMPEG="$(usex ffmpeg OFF ON)"
		-DZM_NO_CURL="$(usex curl OFF ON)"
		-DZM_NO_LIBVLC="$(usex vlc OFF ON)"
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenSSL="$(usex ssl OFF ON)"
		-DHAVE_GNUTLS="$(usex gnutls ON OFF)"
		-DHAVE_GCRYPT="$(usex gcrypt ON OFF)"
	)

	cmake-utils_src_configure

}

src_install() {
	cmake-utils_src_install

	# the log directory
	keepdir /var/log/zm
	fowners apache:apache /var/log/zm

	# the logrotate script
	insinto /etc/logrotate.d
	newins distros/ubuntu1204/zoneminder.logrotate zoneminder

	# now we duplicate the work of zmlinkcontent.sh
	keepdir /var/lib/zoneminder /var/lib/zoneminder/images /var/lib/zoneminder/events /var/lib/zoneminder/api_tmp
	fperms -R 0775 /var/lib/zoneminder
	fowners -R apache:apache /var/lib/zoneminder
	dosym /var/lib/zoneminder/images ${MY_ZM_WEBDIR}/images
	dosym /var/lib/zoneminder/events ${MY_ZM_WEBDIR}/events
	dosym /var/lib/zoneminder/api_tmp ${MY_ZM_WEBDIR}/api/app/tmp

	# bug 523058
	keepdir ${MY_ZM_WEBDIR}/temp
	fowners -R apache:apache ${MY_ZM_WEBDIR}/temp

	# the configuration file
	fperms 0640 /etc/zm.conf
	fowners root:apache /etc/zm.conf

	# init scripts etc
	newinitd "${FILESDIR}"/init.d zoneminder
	newconfd "${FILESDIR}"/conf.d zoneminder

	# systemd unit file
	systemd_dounit "${FILESDIR}"/zoneminder.service

	cp "${FILESDIR}"/10_zoneminder.conf "${T}"/10_zoneminder.conf || die
	sed -i "${T}"/10_zoneminder.conf -e "s:%ZM_WEBDIR%:${MY_ZM_WEBDIR}:g" || die

	dodoc AUTHORS BUGS ChangeLog INSTALL NEWS README.md TODO "${T}"/10_zoneminder.conf

	perl_delete_packlist

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	local v
	for v in ${REPLACING_VERSIONS}; do
		if ! version_is_at_least ${PV} ${v}; then
			elog "You have upgraded zoneminder and may have to upgrade your database now using the 'zmupdate.pl' script."
		fi
	done
}
