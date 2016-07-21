# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2 prefix user

MY_P="apache-${P}-src"

DESCRIPTION="Tomcat Servlet-3.0/JSP-2.2 Container"
HOMEPAGE="http://tomcat.apache.org/"
SRC_URI="mirror://apache/${PN}/tomcat-7/v${PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="7"
KEYWORDS="amd64 ppc64 x86 ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="extra-webapps websockets"

RESTRICT="test" # can we run them on a production system?

ECJ_SLOT="4.4"
SAPI_SLOT="3.0"

COMMON_DEP="dev-java/eclipse-ecj:${ECJ_SLOT}
	dev-java/oracle-javamail:0
	dev-java/tomcat-servlet-api:${SAPI_SLOT}"
RDEPEND="${COMMON_DEP}
	websockets? ( >=virtual/jre-1.7 )
	!websockets? ( >=virtual/jre-1.6 )
	!<dev-java/tomcat-native-1.1.24"
DEPEND="${COMMON_DEP}
	websockets? ( >=virtual/jdk-1.7 )
	!websockets? ( >=virtual/jdk-1.6 )
	test? ( dev-java/ant-junit:0 )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup tomcat 265
	enewuser tomcat 265 -1 /dev/null tomcat
}

java_prepare() {
	# Remove bundled javamail, servlet-api
	rm -rv java/javax/{el,mail,servlet} || die

	java-pkg_clean

	epatch "${FILESDIR}/${P}-build.xml.patch"

	# For use of catalina.sh in netbeans
	sed -i -e "/^# ----- Execute The Requested Command/ a\
		CLASSPATH=\`java-config --classpath ${PN}-${SLOT}\`" \
		bin/catalina.sh || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_BUILD_TARGET="deploy"
EANT_GENTOO_CLASSPATH="eclipse-ecj-${ECJ_SLOT},oracle-javamail,tomcat-servlet-api-${SAPI_SLOT}"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/output/classes"
EANT_NEEDS_TOOLS="true"
EANT_EXTRA_ARGS="-Dversion=${PV}-gentoo -Dversion.number=${PV} -Dcompile.debug=false"

# revisions of the scripts
IM_REV="-r1"
INIT_REV="-r1"

src_compile() {
	use websockets && EANT_EXTRA_ARGS+=" -Djava.7.home=${JAVA_HOME}"
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant-core ant.jar)"
	java-pkg-2_src_compile
}

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

	dodoc RELEASE-NOTES RUNNING.txt
	use doc && java-pkg_dojavadoc output/dist/webapps/docs/api
	use source && java-pkg_dosrc java/*

	### Webapps ###

	insinto "${dest}"/webapps
	doins -r output/build/webapps/{host-manager,manager,ROOT}
	use extra-webapps && doins -r output/build/webapps/{docs,examples}

	### Config ###

	# create "logs" directory in $CATALINA_BASE
	# and set correct perms, see #458890
	dodir "${dest}"/logs
	fperms 0750 "${dest}"/logs

	# replace the default pw with a random one, see #92281
	local randpw=$(echo ${RANDOM}|md5sum|cut -c 1-15)
	sed -i -e "s|SHUTDOWN|${randpw}|" output/build/conf/server.xml || die

	# prepend gentoo.classpath to common.loader, see #453212
	sed -i -e 's/^common\.loader=/\0${gentoo.classpath},/' output/build/conf/catalina.properties || die

	insinto "${dest}"
	doins -r output/build/conf

	### rc ###

	cp "${FILESDIR}"/tomcat{.conf,${INIT_REV}.init,-instance-manager${IM_REV}.bash} "${T}" || die
	eprefixify "${T}"/tomcat{.conf,${INIT_REV}.init,-instance-manager${IM_REV}.bash}
	sed -i -e "s|@SLOT@|${SLOT}|g" "${T}"/tomcat{.conf,${INIT_REV}.init,-instance-manager${IM_REV}.bash} || die

	insinto "${dest}"/gentoo
	doins "${T}"/tomcat.conf
	exeinto "${dest}"/gentoo
	newexe "${T}"/tomcat${INIT_REV}.init tomcat.init
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

#	einfo "Please read https://www.gentoo.org/proj/en/java/tomcat6-guide.xml for more information."
}
