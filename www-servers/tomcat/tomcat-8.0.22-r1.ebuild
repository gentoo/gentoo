# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tomcat/tomcat-8.0.22-r1.ebuild,v 1.1 2015/06/09 09:24:32 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 prefix user

MY_P="apache-${P}-src"

DESCRIPTION="Tomcat Servlet-3.1/JSP-2.3 Container"
HOMEPAGE="http://tomcat.apache.org/"
SRC_URI="mirror://apache/${PN}/tomcat-8/v${PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="8"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="extra-webapps"

RESTRICT="test" # can we run them on a production system?

ECJ_SLOT="4.4"
SAPI_SLOT="3.1"

COMMON_DEP="dev-java/eclipse-ecj:${ECJ_SLOT}
	~dev-java/tomcat-servlet-api-${PV}:${SAPI_SLOT}"
RDEPEND="${COMMON_DEP}
	!<dev-java/tomcat-native-1.1.24
	>=virtual/jre-1.7"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.7
	>=dev-java/ant-core-1.8.1:0
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup tomcat 265
	enewuser tomcat 265 -1 /dev/null tomcat
}

java_prepare() {
	find -name '*.jar' -type f -delete -print || die

	epatch "${FILESDIR}/${P}-build.xml.patch"

	# For use of catalina.sh in netbeans
	sed -i -e "/^# ----- Execute The Requested Command/ a\
		CLASSPATH=\`java-config --classpath ${PN}-${SLOT}\`" \
		bin/catalina.sh || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_BUILD_TARGET="deploy"
EANT_GENTOO_CLASSPATH="tomcat-servlet-api-${SAPI_SLOT},eclipse-ecj-${ECJ_SLOT}"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/output/classes"
EANT_NEEDS_TOOLS="true"
EANT_EXTRA_ARGS="-Dversion=${PV}-gentoo -Dversion.number=${PV} -Dcompile.debug=false"

# revision of the instance-manager script
IM_REV="-r1"

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant-core ant.jar)"
	java-pkg-2_src_compile
}

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	local dest="/usr/share/${PN}-${SLOT}"

	java-pkg_jarinto "${dest}"/bin
	java-pkg_dojar output/build/bin/*.jar
	exeinto "${dest}"/bin
	doexe output/build/bin/*.sh

	java-pkg_jarinto "${dest}"/lib
	java-pkg_dojar output/build/lib/*.jar

	# so we don't have to call java-config with --with-dependencies, which might
	# bring in more jars then actually desired.
	java-pkg_addcp "$(java-pkg_getjars eclipse-ecj-${ECJ_SLOT},tomcat-servlet-api-${SAPI_SLOT})"

	dodoc RELEASE-NOTES RUNNING.txt
	use doc && java-pkg_dojavadoc output/dist/webapps/docs/api
	use source && java-pkg_dosrc java/*

	### Webapps ###

	insinto "${dest}"/webapps
	doins -r output/build/webapps/{host-manager,manager,ROOT}
	use extra-webapps && doins -r output/build/webapps/{docs,examples}

	### Config ###

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -i -e "s|SHUTDOWN|${randpw}|" output/build/conf/server.xml || die

	insinto "${dest}"
	doins -r output/build/conf

	### rc ###

	cp "${FILESDIR}"/tomcat{.conf,.init,-instance-manager${IM_REV}.bash} "${T}" || die
	eprefixify "${T}"/tomcat{.conf,.init,-instance-manager${IM_REV}.bash}
	sed -i -e "s|@SLOT@|${SLOT}|g" "${T}"/tomcat{.conf,.init,-instance-manager${IM_REV}.bash} || die

	insinto "${dest}"/gentoo
	doins "${T}"/tomcat.conf
	exeinto "${dest}"/gentoo
	doexe "${T}"/tomcat.init
	newexe "${T}"/tomcat-instance-manager${IM_REV}.bash tomcat-instance-manager.bash
}

pkg_postinst() {
	elog "New ebuilds of Tomcat support running multiple instances. If you used prior version"
	elog "of Tomcat (<7.0.32), you have to migrate your existing instance to work with new Tomcat."
	elog "You can find more information at https://wiki.gentoo.org/wiki/Apache_Tomcat"

	elog "To manage Tomcat instances, run:"
	elog "  ${EPREFIX}/usr/share/${PN}-${SLOT}/gentoo/tomcat-instance-manager.bash --help"

	ewarn "tomcat-dbcp.jar is not built at this time. Please fetch jar"
	ewarn "from upstream binary if you need it. Gentoo Bug # 144276"

#	einfo "Please read http://www.gentoo.org/proj/en/java/tomcat6-guide.xml for more information."
}
