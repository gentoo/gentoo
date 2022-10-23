# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="tomcat-connectors-${PV#-*}-src"

inherit apache-module autotools

DESCRIPTION="Provides an AJP Apache2-JK-connector for the Tomcat servlet engine"
HOMEPAGE="https://tomcat.apache.org/connectors-doc/"
SRC_URI="mirror://apache/tomcat/tomcat-connectors/jk/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/native"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86"

DEPEND="dev-libs/apr:1="
RDEPEND="${DEPEND}"
BDEPEND="dev-lang/perl"

APACHE2_MOD_FILE="${S}/apache-2.0/${PN}.so"
APACHE2_MOD_DEFINE="JK"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

need_apache2

pkg_setup() {
	# Calling depend.apache_pkg_setup fails because we do not have
	# "apache2" in IUSE but the function expects this in order to call
	# _init_apache2_late which sets the APACHE_MODULESDIR variable.
	_init_apache2
	_init_apache2_late
}

src_prepare() {
	default

	# Don't add '-Wl,' as prefix for CFLAGS, as linker will fail
	sed -e '/JK_PREFIX_IF_MISSING/d' -i configure.ac || die
	eautoreconf

	# Adjust confpath and logpath for Gentoo
	local logs_path="/var/log/apache2"
	sed -e "s|conf|${APACHE_CONFDIR}|g" -e "s|logs|${logs_path}|g" -i ../conf/httpd-jk.conf || die
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--with-apxs="${APXS}"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	LIBTOOL="/bin/sh $(pwd)/libtool --silent"
	default
}

src_install() {
	apache-module_src_install

	insinto "${APACHE_CONFDIR}"
	doins "${S}"/../conf/*.properties

	insinto "${APACHE_MODULES_CONFDIR}"
	newins ../conf/httpd-jk.conf 88_mod_jk.conf

	einstalldocs
}
