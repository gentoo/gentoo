# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 prefix

MY_P="apache-${PN}-${PV}-src"

# Currently we bundle binary versions of bnd.jar and bndlib.jar
# See bugs #203080 and #676116
BND_VERSION="6.3.1"
BND="biz.aQute.bnd-${BND_VERSION}.jar"
BNDLIB="biz.aQute.bndlib-${BND_VERSION}.jar"

DESCRIPTION="Tomcat Servlet-4.0/JSP-2.3/EL-3.0/WebSocket-1.1/JASPIC-1.1 Container"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/${PN}/tomcat-9/v${PV}/src/${MY_P}.tar.gz
	https://repo.maven.apache.org/maven2/biz/aQute/bnd/biz.aQute.bnd/${BND_VERSION}/${BND}
	https://repo.maven.apache.org/maven2/biz/aQute/bnd/biz.aQute.bndlib/${BND_VERSION}/${BNDLIB}"

LICENSE="Apache-2.0"
SLOT="9"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="extra-webapps"

RESTRICT="test" # can we run them on a production system?

# though it could work with 4.22 and upstream uses 4.20,
# we still use 4.15 because 4.20+ is currently built with java 11
# and it would force Tomcat to use at least java 11 too
ECJ_SLOT="4.15"
SERVLET_API_SLOT="4.0"
JSP_API_SLOT="2.3"
EL_API_SLOT="3.0"

COMMON_DEP="dev-java/eclipse-ecj:${ECJ_SLOT}
	dev-java/glassfish-xmlrpc-api:0
	~dev-java/tomcat-el-api-${PV}:${EL_API_SLOT}
	~dev-java/tomcat-jsp-api-${PV}:${JSP_API_SLOT}
	~dev-java/tomcat-servlet-api-${PV}:${SERVLET_API_SLOT}
	dev-java/wsdl4j:0"
RDEPEND="${COMMON_DEP}
	acct-group/tomcat
	acct-user/tomcat
	>=virtual/jre-1.8:*"
DEPEND="${COMMON_DEP}
	app-admin/pwgen
	>=dev-java/ant-core-1.9.13
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/ant-junit-1.9:0
		dev-java/easymock:3.2
	)"

S=${WORKDIR}/${MY_P}

PATCHES=(
	"${FILESDIR}/${PN}-9.0.50-insufficient-ecj.patch"
)

BND_HOME="${S}/tomcat-build-libs/bnd"
BNDLIB_HOME="${S}/tomcat-build-libs/bndlib"
BND_JAR="${BND_HOME}/${BND}"
BNDLIB_JAR="${BNDLIB_HOME}/${BND_LIB}"

src_unpack() {
	unpack ${MY_P}.tar.gz

	mkdir -p "${BND_HOME}" "${BNDLIB_HOME}" || die "Failed to create dir"
	ln -s "${DISTDIR}/${BND}" "${BND_HOME}/" || die "Failed to symlink bnd-*.jar"
	ln -s "${DISTDIR}/${BND}" "${BNDLIB_HOME}/" || die "Failed to symlink bndlib-*.jar"
}

src_prepare() {
	default

	find -name '*.jar' -type f -delete -print || die

	# Remove bundled servlet-api
	rm -rv java/javax/{el,servlet} || die

	eapply "${FILESDIR}/${PN}-9.0.62-build.xml.patch"

	# For use of catalina.sh in netbeans
	sed -i -e "/^# ----- Execute The Requested Command/ a\
		CLASSPATH=\`java-config --with-dependencies --classpath ${PN}-${SLOT}\`" \
		bin/catalina.sh || die

	java-pkg-2_src_prepare
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_BUILD_TARGET="deploy"
EANT_GENTOO_CLASSPATH="eclipse-ecj-${ECJ_SLOT},tomcat-servlet-api-${SERVLET_API_SLOT},tomcat-jsp-api-${JSP_API_SLOT},tomcat-el-api-${EL_API_SLOT},wsdl4j"
EANT_TEST_GENTOO_CLASSPATH="easymock-3.2"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/output/classes"
EANT_NEEDS_TOOLS="true"
EANT_EXTRA_ARGS="-Dversion=${PV}-gentoo -Dversion.number=${PV} -Dcompile.debug=false -Dbnd.jar=${BND_JAR} -Dbndlib.jar=${BNDLIB_JAR}"

# revisions of the scripts
IM_REV="-r2"
INIT_REV="-r1"

src_configure() {
	java-ant-2_src_configure

	eapply "${FILESDIR}/${PN}-9.0.37-fix-build-rewrite.patch"
}

src_compile() {
	EANT_GENTOO_CLASSPATH_EXTRA+=":$(java-pkg_getjar --build-only ant-core ant.jar):$(java-pkg_getjars --build-only glassfish-xmlrpc-api)"
	LC_ALL=C java-pkg-2_src_compile
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

	# add missing docBase
	local apps="host-manager manager"
	for app in ${apps}; do
		sed -i -e "s|=\"true\" >|=\"true\" docBase=\"\$\{catalina.home\}/webapps/${app}\" >|" \
			output/build/webapps/${app}/META-INF/context.xml || die
	done

	insinto "${dest}"/webapps
	doins -r output/build/webapps/{host-manager,manager,ROOT}
	use extra-webapps && doins -r output/build/webapps/{docs,examples}

	### Config ###

	# create "logs" directory in $CATALINA_BASE
	# and set correct perms, see #458890
	dodir "${dest}"/logs
	fperms 0750 "${dest}"/logs

	# replace the default pw with a random one, see #92281
	local randpw="$(pwgen -s -B 15 1)"
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

	einfo "Please read https://wiki.gentoo.org/wiki/Apache_Tomcat and"
	einfo "https://wiki.gentoo.org/wiki/Project:Java/Tomcat_6_Guide for more information."
}
