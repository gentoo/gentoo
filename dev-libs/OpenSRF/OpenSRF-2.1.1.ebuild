# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/OpenSRF/OpenSRF-2.1.1.ebuild,v 1.2 2014/11/19 19:36:54 dilfridge Exp $

EAPI=5
inherit eutils multilib flag-o-matic apache-module autotools perl-module

DESCRIPTION="Framework for the high-level development of the Evergreen ILS software"
HOMEPAGE="http://open-ils.org/"
MY_PN="opensrf" # upstream lowercased the tarball in 2.x
MY_P="${MY_PN}-${PV}"
SRC_URI="http://open-ils.org/downloads/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="postgres +sqlite"
DEPEND=">=www-servers/apache-2.2.9
		>=dev-db/libdbi-drivers-0.8.2
		>=dev-db/libdbi-0.8.2
		net-im/ejabberd
		dev-libs/libmemcache
		dev-perl/Cache-Memcached
		dev-perl/Class-DBI-AbstractSearch
		sqlite? ( dev-perl/DBD-SQLite )
		postgres? ( dev-perl/DBD-Pg )
		virtual/perl-Digest-MD5
		dev-perl/JSON-XS
		dev-perl/net-server
		dev-perl/UNIVERSAL-require
		dev-perl/Unix-Syslog
		dev-perl/XML-LibXML
		"

S="${WORKDIR}/${MY_P}"
PERL_S="${S}/src/perl"

APXS2_S="${S}/src/gateway/.libs/"
APACHE2_MOD_FILE="${APXS2_S}/osrf_json_gateway.so ${APXS2_S}/osrf_http_translator.so"
#APACHE2_MOD_CONF="42_${PN}"
#APACHE2_MOD_DEFINE="FOO"
#DOCFILES="docs/*.html"
need_apache2_2

RDEPEND="${DEPEND}"

pkg_setup() {
	perl_set_version
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.1.1-buildfix.patch
	eautoreconf
}

#src_compile() {
#	LIBXML2_CFLAGS=$(xml2-config --cflags)
#	LIBXML2_CFLAGS="${LIBXML2_CFLAGS//*-I}"
#	LIBXML2_HEADERS="${LIBXML2_CFLAGS// *}"
#	APR_HEADERS=$(apr-1-config --includedir)
#	APACHE2_HEADERS=$(apxs2 -q INCLUDEDIR)
#	sed -i \
#		-e '/^export PREFIX=/s,/.*,/usr,' \
#		-e '/^export BINDIR=/s,/.*,${PREFIX}/bin,' \
#		-e "/^export LIBDIR=/s,/.*,\${PREFIX}/$(get_libdir)," \
#		-e '/^export PERLDIR=/s,/.*,${LIBDIR}/perl5,' \
#		-e '/^export INCLUDEDIR=/s,/.*,${PREFIX}/include,' \
#		-e '/^export ETCDIR=/s,/.*,/etc,' \
#		-e '/^export SOCK=/s,/.*,/var/run/opensrf,' \
#		-e '/^export PID=/s,/.*,/var/run/opensrf,' \
#		-e '/^export LOG=/s,/.*,/var/log,' \
#		-e '/^export TMP=/s,/.*,/tmp,' \
#		-e '/^export APXS2=/s,/.*,/usr/sbin/apxs2,' \
#		-e "/^export APACHE2_HEADERS=/s,/.*,${APACHE2_HEADERS}," \
#		-e "/^export APR_HEADERS=/s,/.*,${APR_HEADERS}," \
#		-e "/^export LIBXML2_HEADERS=/s,/.*,${LIBXML2_HEADERS}," \
#		install.conf
#	emake verbose || die "Failed to build"
#}
src_configure() {
	APXS2_INSTALL="-i" \
	econf \
		--with-apxs=/usr/sbin/apxs2 \
		--sysconfdir=/etc/opensrf \
		--localstatedir=/var \
		|| die "econf failed"
	cd "${PERL_S}" && S="${PERL_S}" perl-module_src_configure || die "perl-module_src_configure failed"
}

src_compile() {
	emake || die "main emake failed"
	cd "${PERL_S}" && S="${PERL_S}" perl-module_src_compile || die "perl-module_src_compile failed"
}

src_install() {
	einfo "Doing src_install"
	#emake install-verbose DESTDIR="${D}" || die "Failed to install"
	emake install DESTDIR="${D}" APXS2_INSTALL="-i" || die "Failed to install"
	apache-module_src_install || die "apache-module_src_install failed"
	cd "${PERL_S}" && S="${PERL_S}" perl-module_src_install || die "perl-module_src_install failed"
	cd "${S}"

	# Docs
	dodoc README doc/*
}

src_test() {
	emake check || die "emake check failed"
	cd "${PERL_S}" && S="${PERL_S}" perl-module_src_test || die "perl-module_src_test failed"
}

pkg_config() {
	:
	#JABBER_SERVER=${JABBER_SERVER:=localhost}
	#JABBER_PORT=${JABBER_PORT:=5222}
	#PASSWORD=${PASSWORD:=osrf}
	#einfo "Using Jabber server at ${JABBER_SERVER}:${JABBER_PORT}"
	#einfo "Adding 'osrf' and 'router' users with password ${PASSWORD}"
	#cd "${ROOT}"/usr/share/doc/${PF}/examples
	#for user in osrf router ; do
	#	perl register.pl ${JABBER_SERVER} ${JABBER_PORT} ${user} ${PASSWORD} \
	#		|| die "Failed to add $user user to server"
	#done
}
