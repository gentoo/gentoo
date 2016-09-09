# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 prefix user

MY_PV="${PV/_alpha/.M}"
MY_P="apache-${PN}-${MY_PV}-src"

DESCRIPTION="Tomcat Servlet-4.0/JSP-2.3 Container"
HOMEPAGE="http://tomcat.apache.org/"
SRC_URI="mirror://apache/${PN}/tomcat-9/v${MY_PV}/src/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="9"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="extra-webapps"

RESTRICT="test" # can we run them on a production system?

COMMON_DEP="~dev-java/tomcat-server-${PV}:${SLOT}
	~dev-java/tomcat-servlet-api-${PV}:4.0"

DEPEND="${COMMON_DEP}
	app-admin/pwgen
	>=virtual/jdk-1.8
	test? (
		>=dev-java/ant-junit-1.9:0
		dev-java/easymock:3.2
	)"

RDEPEND="${COMMON_DEP}
	!<dev-java/tomcat-native-1.1.24
	>=virtual/jre-1.8"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	java-pkg-2_pkg_setup
	enewgroup tomcat 265
	enewuser tomcat 265 -1 /dev/null tomcat
}

java_prepare() {
	eapply_user
	# Remove bundled servlet-api
	rm -rv java/javax/{el,servlet} || die

	# For use of catalina.sh in netbeans
	sed -i -e "/^# ----- Execute The Requested Command/ a\
		CLASSPATH=\`java-config --classpath ${PN}-${SLOT}\`" \
		bin/catalina.sh || die
}

# Needed to create classpath in package.env
EANT_GENTOO_CLASSPATH="tomcat-server-${SLOT}"

# Not sure if tests can be run
EANT_TEST_GENTOO_CLASSPATH="easymock-3.2"

# revisions of the scripts
IM_REV="-r2"
INIT_REV=""

src_compile() {
	local donothing;
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	local dest="/usr/share/${PN}-${SLOT}"

	dodir "${dest}"/bin
	# link to jars installed by tomcat-server
	local bin_jars="bootstrap tomcat-juli"
	for jar in ${bin_jars}; do
		dosym /usr/share/${PN}-server-${SLOT}/lib/${jar}.jar \
			"${dest}"/bin/${jar}.jar
	done
	exeinto "${dest}"/bin
	doexe bin/*.sh

	local lib_jars="annotations-api catalina-ant catalina-ha
			catalina-storeconfig catalina-tribes catalina
			jasper-el jasper jaspic-api tomcat-api tomcat-coyote
			tomcat-dbcp tomcat-i18n-es tomcat-i18n-fr
			tomcat-i18n-ja tomcat-jni tomcat-util-scan tomcat-util
			tomcat-websocket websocket-api"
	for jar in ${lib_jars}; do
		dosym /usr/share/${PN}-server-${SLOT}/lib/${jar}.jar \
			"${dest}"/lib/${jar}.jar
	done

	dodoc RELEASE-NOTES RUNNING.txt
	use doc && java-pkg_dojavadoc webapps/docs/api
	use source && java-pkg_dosrc java/*

	### Webapps ###

	# add missing docBase
	local apps="host-manager manager"
	for app in ${apps}; do
		sed -i -e "s|=\"true\" >|=\"true\" docBase=\"\$\{catalina.home\}/webapps/${app}\" >|" \
			webapps/${app}/META-INF/context.xml || die
	done

	insinto "${dest}"/webapps
	doins -r webapps/{host-manager,manager,ROOT}
	use extra-webapps && doins -r webapps/{docs,examples}

	### Config ###

	# create "logs" directory in $CATALINA_BASE
	# and set correct perms, see #458890
	dodir "${dest}"/logs
	fperms 0750 "${dest}"/logs

	# replace the default pw with a random one, see #92281
	local randpw="$(pwgen -s -B 15 1)"
	sed -i -e "s|SHUTDOWN|${randpw}|" conf/server.xml || die

	# prepend gentoo.classpath to common.loader, see #453212
	sed -i -e 's/^common\.loader=/\0${gentoo.classpath},/' conf/catalina.properties || die

	insinto "${dest}"
	doins -r conf

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
}
