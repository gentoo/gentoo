# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="https://www.scala-sbt.org/"
SRC_URI="
	https://github.com/sbt/sbt/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${P}-deps.tar.xz
"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

# Each build with separate java slots requires slightly different deps?
# Either that else I cannot build with jdk:8 / jdk:17
# Locked in jdk:11 as it seems like a sensible default.
DEPEND="virtual/jdk:11"
RDEPEND=">=virtual/jre-1.8:*"

# NOTES FOR BUMPING:
# 1. Remove the deps tarball in SRC_URI.
# 2. Emerge the package without network-sandbox to download all deps.
# 	 	- Ensure you fail before installation if you wish to do so.
# 		- sbt may download more deps when running tests.
# 		- "FEATURES='noclean -network-sandbox test' emerge -v1 dev-java/sbt"
# 3. cd to ${WORKDIR}
# 4. Create the deps tarball:
# 		- "XZ_OPT=-9 tar --owner=portage --group=portage -cJf /var/cache/distfiles/${P}-deps.tar.xz \
# 			.cache/ .ivy2/cache/ .sbt/ sbt-${PV}/target/ivyhome/cache/"
# 5. Undo any temporary edits to the ebuild.

src_compile() {
	local vm_version="$(java-config -g PROVIDES_VERSION)"

	einfo "=== sbt compile with jdk ${vm_version} ==="
	./sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" compile || die

	einfo "=== sbt publishLocal with jdk ${vm_version} ==="
	./sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" publishLocal || die
}

src_test() {
	einfo "=== sbt test with jdk ${vm_version} ==="
	./sbt -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" test || die
}

src_install() {
	# Place sbt-launch.jar at the end of the CLASSPATH
	java-pkg_dojar \
		$(find "${WORKDIR}"/.ivy2/local -name \*.jar -print | grep -v sbt-launch.jar) \
		$(find "${WORKDIR}"/.ivy2/local -name sbt-launch.jar -print)

	local javaags="-Dsbt.version=${PV} -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
	java-pkg_dolauncher sbt --jar sbt-launch.jar --java_args "${javaags}"
}
