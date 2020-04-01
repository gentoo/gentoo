# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils depend.apache eapi7-ver flag-o-matic perl-functions readme.gentoo-r1 systemd

MY_PN="ZoneMinder"

MY_CRUD_VERSION="3.1.0-zm"
MY_CAKEPHP_VERSION="1.0-zm"

DESCRIPTION="Capture, analyse, record and monitor any cameras attached to your system"
HOMEPAGE="https://zoneminder.com/ https://github.com/ZoneMinder/zoneminder"
SRC_URI="
	https://github.com/${MY_PN}/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/${MY_PN}/crud/archive/${MY_CRUD_VERSION}.tar.gz -> crud-${MY_CRUD_VERSION}.tar.gz
	https://github.com/${MY_PN}/CakePHP-Enum-Behavior/archive/${MY_CAKEPHP_VERSION}.tar.gz -> CakePHP-Enum-Behavior-${MY_CAKEPHP_VERSION}.tar.gz
"

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="curl gcrypt gnutls libressl +mmap +ssl vlc"
SLOT="0"
REQUIRED_USE="
	|| ( ssl gnutls )
"

DEPEND="
	app-eselect/eselect-php[apache2]
	dev-db/mysql-connector-c:0=
	dev-lang/perl:=
	dev-lang/php:*[apache2,cgi,curl,gd,inifile,pdo,mysql,mysqli,sockets]
	dev-libs/libpcre
	dev-perl/Archive-Zip
	dev-perl/Class-Std-Fast
	dev-perl/DBD-mysql
	dev-perl/DBI
	dev-perl/Data-Dump
	dev-perl/Data-UUID
	dev-perl/Date-Manip
	dev-perl/Device-SerialPort
	dev-perl/IO-Socket-Multicast
	dev-perl/MIME-Lite
	dev-perl/MIME-tools
	dev-perl/PHP-Serialization
	dev-perl/SOAP-WSDL
	dev-perl/Sys-CPU
	dev-perl/Sys-MemInfo
	dev-perl/URI-Encode
	dev-perl/libwww-perl
	dev-php/pecl-apcu:*
	sys-libs/zlib
	virtual/ffmpeg
	virtual/httpd-php:*
	virtual/jpeg:0
	virtual/perl-Archive-Tar
	virtual/perl-ExtUtils-MakeMaker
	virtual/perl-Getopt-Long
	virtual/perl-Module-Load
	virtual/perl-Sys-Syslog
	virtual/perl-Time-HiRes
	virtual/perl-libnet
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
	"${FILESDIR}/${PN}"-1.34-systemd.patch
)

MY_ZM_WEBDIR=/usr/share/zoneminder/www

src_prepare() {
	cmake-utils_src_prepare
	rmdir "${S}/web/api/app/Plugin/Crud" || die
	mv "${WORKDIR}/crud-${MY_CRUD_VERSION}" "${S}/web/api/app/Plugin/Crud" || die
	rmdir "${S}/web/api/app/Plugin/CakePHP-Enum-Behavior" || die
	mv "${WORKDIR}/CakePHP-Enum-Behavior-${MY_CAKEPHP_VERSION}" "${S}/web/api/app/Plugin/CakePHP-Enum-Behavior" || die

	cp "${FILESDIR}"/10_zoneminder.conf "${S}"/10_zoneminder.conf || die
	sed -i "${S}"/10_zoneminder.conf -e "s:%ZM_WEBDIR%:${MY_ZM_WEBDIR}:g" || die
}

src_configure() {
	append-cxxflags -D__STDC_CONSTANT_MACROS
	perl_set_version
	export TZ=UTC # bug 630470
	mycmakeargs=(
		-DZM_CONFIG_DIR=/etc/zm
		-DZM_NO_CURL="$(usex curl OFF ON)"
		-DZM_NO_LIBVLC="$(usex vlc OFF ON)"
		-DZM_NO_MMAP="$(usex mmap OFF ON)"
		-DZM_NO_X10=OFF
		-DZM_SOCKDIR=/var/run/zm
		-DZM_TMPDIR=/var/tmp/zm
		-DZM_WEBDIR=${MY_ZM_WEBDIR}
		-DZM_WEB_GROUP=apache
		-DZM_WEB_USER=apache
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenSSL="$(usex ssl OFF ON)"
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

	# bug 523058
	keepdir ${MY_ZM_WEBDIR}/temp
	fowners -R apache:apache ${MY_ZM_WEBDIR}/temp

	# the configuration file
	fperms 0640 /etc/zm/zm.conf
	fowners root:apache /etc/zm/zm.conf

	# init scripts etc
	newinitd "${FILESDIR}"/init.d zoneminder
	newconfd "${FILESDIR}"/conf.d zoneminder

	# systemd unit file
	systemd_dounit "${FILESDIR}"/zoneminder.service

	dodoc README.md "${S}"/10_zoneminder.conf

	perl_delete_packlist

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog

	local v
	for v in ${REPLACING_VERSIONS}; do
		if ver_test ${PV} -gt ${v}; then
			elog "You have upgraded zoneminder and may have to upgrade your database now using the 'zmupdate.pl' script."
		fi
	done
}
