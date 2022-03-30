# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

# NB: this project is dead and we should look into removing it from the tree.
# Take a look at the homepage.
# As of February 2022, dev-java/commons-logging is the only consumer of this
# package besides dev-java/avalon-framework.  However, commons-logging is still
# used by many other consumers and does not have an updated version that do not
# depend on this package.
DESCRIPTION="Easy-to-use Java logging toolkit"
HOMEPAGE="https://avalon.apache.org/closed.html"
SRC_URI="https://archive.apache.org/dist/excalibur/avalon-logkit/source/avalon-logkit-${PV}-src.tar.gz"

KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"
LICENSE="Apache-2.0"
SLOT="2.0"

CP_DEPEND="
	dev-java/javax-mail:0
	dev-java/jboss-jms-api:1.1
	dev-java/log4j-12-api:2
	java-virtuals/servlet-api:3.0"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit:0
	)"

src_prepare() {
	default

	# Unfortunately, LogFactor5 support is no longer provided by the Log4j 1.x
	# bridge in Log4j 2.  But it seems that LogFactor5 merely consists of a
	# Swing-based GUI that is neither checked by this package's tests nor used
	# by reverse dependencies in ::gentoo.  If virtually nobody would use
	# LogFactor5, components in this package pertaining to it could be simply
	# removed to make the migration to Log4j 2 feasible.
	# http://people.apache.org/~carnold/log4j/docs/x/logging-log4j-1.2.10/docs/lf5/overview.html
	rm -rv src/java/org/apache/log/output/lf5 ||
		die "Failed to remove support for stale LogFactor5 project"

	# Doesn't like 1.6 / 1.7 changes to JDBC
	eapply "${FILESDIR}/${P}-java7.patch"

	java-ant_ignore-system-classes

	java-ant_xml-rewrite \
		-f build.xml \
		-c -e available \
		-a classpathref \
		-v 'build.classpath' || die

	java-pkg_filter-compiler jikes
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_ENCODING="UTF-8"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "target/${P}.jar"
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}

pkg_postinst() {
	# Display a message about LogFactor5 support drop upon first install
	# or upgrade from a version before the drop
	local changed_ver="2.1-r11"
	local should_show_msg replaced_ver
	[[ -z "${REPLACING_VERSIONS}" ]] && should_show_msg=1 # First install
	for replaced_ver in ${REPLACING_VERSIONS}; do
		if ver_test "${replaced_ver}" -lt "${changed_ver}"; then
			should_show_msg=1
			break
		fi
	done
	[[ "${should_show_msg}" ]] || return
	ewarn "Due to migration to Log4j 2, this package has to drop LogFactor5"
	ewarn "support. As a result, the org.apache.log.output.lf5 Java package"
	ewarn "is not available in the JAR installed by this package."
}
