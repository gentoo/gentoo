# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 prefix

MY_P="apache-${PN}-${PV}-src"

# Currently we bundle binary versions of bnd.jar and bndlib.jar
# See bugs #203080 and #676116
BND_VERSION="6.2.0"
BND="biz.aQute.bnd-${BND_VERSION}.jar"
BNDLIB="biz.aQute.bndlib-${BND_VERSION}.jar"

DESCRIPTION="Tomcat Servlet-5.0/JSP-3.0/EL-4.0/WebSocket-2.0/JASIC-2.0 Container"
HOMEPAGE="https://tomcat.apache.org/"
SRC_URI="mirror://apache/${PN}/tomcat-9/v${PV}/src/${MY_P}.tar.gz
	https://repo.maven.apache.org/maven2/biz/aQute/bnd/biz.aQute.bnd/${BND_VERSION}/${BND}
	https://repo.maven.apache.org/maven2/biz/aQute/bnd/biz.aQute.bndlib/${BND_VERSION}/${BNDLIB}"

LICENSE="Apache-2.0"
SLOT="10"
KEYWORDS="amd64 ~amd64-linux"
IUSE="extra-webapps"

RESTRICT="test" # can we run them on a production system?

# though it could work with 4.22 and upstream uses 4.20,
# we still use 4.15 because 4.20+ is currently built with java 11
# and it would force Tomcat to use at least java 11 too
ECJ_SLOT="4.15"
SAPI_SLOT="5.0"

COMMON_DEP="dev-java/eclipse-ecj:${ECJ_SLOT}
	dev-java/glassfish-xmlrpc-api:0
	dev-java/jakartaee-migration:0
	~dev-java/tomcat-servlet-api-${PV}:${SAPI_SLOT}
	dev-java/wsdl4j:0"
RDEPEND="${COMMON_DEP}
	acct-group/tomcat
	acct-user/tomcat
	virtual/jre"
DEPEND="${COMMON_DEP}
	app-admin/pwgen
	dev-java/ant-core
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
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
	rm -rv java/jakarta/{el,servlet} || die

	eapply "${FILESDIR}/${PN}-10.0.16-build.xml.patch"

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	[[ "${vm_version}" == "1.8" ]] && eapply "${FILESDIR}/${PN}-10.0.16-build.xml-strip-html5.patch"

	# For use of catalina.sh in netbeans
	sed -i -e "/^# ----- Execute The Requested Command/ a\
		CLASSPATH=\`java-config --with-dependencies --classpath ${PN}-${SLOT}\`" \
		bin/catalina.sh || die

	java-pkg-2_src_prepare
}

JAVA_ANT_REWRITE_CLASSPATH="true"

EANT_BUILD_TARGET="deploy"
EANT_GENTOO_CLASSPATH="eclipse-ecj-${ECJ_SLOT},jakartaee-migration,tomcat-servlet-api-${SAPI_SLOT},wsdl4j"
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

	ewarn "Please note that since version 10 the primary package for all implemented APIs"
	ewarn "has changed from javax.* to jakarta.*. This will almost certainly require code"
	ewarn "changes to enable applications to migrate from Tomcat 9 and earlier to Tomcat 10 and later."

	ewarn "tomcat-dbcp.jar is not built at this time. Please fetch jar"
	ewarn "from upstream binary if you need it. Gentoo Bug # 144276"

	einfo "Please read https://wiki.gentoo.org/wiki/Apache_Tomcat and"
	einfo "https://wiki.gentoo.org/wiki/Project:Java/Tomcat_6_Guide for more information."
}
