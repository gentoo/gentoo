# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

L_PN="sbt-launch"
L_P="${L_PN}-${PV}"

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="https://www.scala-sbt.org/"
EGIT_COMMIT="v${PV}"
EGIT_REPO_URI="https://github.com/sbt/sbt.git"
SRC_URI="
	!binary? (
		https://github.com/sbt/sbt/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.xz
		https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.xz
		https://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/${L_PN}/${PV}/${L_PN}.jar -> ${L_P}.jar
	)
	binary? (
		https://dev.gentoo.org/~gienah/distfiles/${P}-gentoo-binary.tar.xz
	)"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"
IUSE="binary"

# Restrict to jdk:1.8
# Missing dependency 'object java.lang.Object in compiler mirror', bug #831297
DEPEND="
	virtual/jdk:1.8
"

RDEPEND="
	>=virtual/jre-1.8:*
"

# test hangs or fails
RESTRICT="test"

# Note: to bump sbt, some things to try are:
# 1. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.xz
# https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.xz and
# binary? ( https://dev.gentoo.org/~gienah/distfiles/${P}-gentoo-binary.tar.xz )
# from SRC_URI
# 2. Comment the sbt publishLocal line in src_compile.
# 3. try:
# FEATURES='noclean -test' emerge -v -1 dev-java/sbt
# It should fail in src_install since the sbt publishLocal is not done.
# Check if it downloads more stuff in
# src_compile to ${WORKDIR}/.ivy2 and ${WORKDIR}/.sbt.
# 4. If some of the downloads fail, it might be necessary to run the sbt compile
# again manually to obtain all the dependencies, if so:
# cd to ${S}
# export EROOT=/
# export WORKDIR='/var/tmp/portage/dev-java/${P}/work'
# export L_P=${P}
# export PATH="${WORKDIR}/${L_P}:${PATH}"
# sbt compile
# cd ${WORKDIR}
# find .ivy2 .sbt -uid 0 -exec chown portage:portage {} \;
# 5. cd ${WORKDIR}
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-ivy2-deps.tar.xz .ivy2/cache
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-sbt-deps.tar.xz .sbt
# Uncomment the sbt publishLocal line in src_compile.
# 6. It *might* download more dependencies for src_test, however the presence
# of some of these may cause the src_compile to fail.  So download them
# seperately as root so we can identify the
# additional files.  As root:
# cd ${S}
# ${S}/${P} test
# cd ${WORKDIR}
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-test-deps.tar.xz \
# $(find .ivy2/cache .sbt -uid 0 -type f -print)
# Note: It might not download anything in src_test, in which case
# ${P}-test-deps.tar.xz is not required.
# 7. Create the binary
# cd $WORDKIR
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-gentoo-binary.tar.xz ${P} .ivy2/local
# 9. Undo the earlier temporary edits to the ebuild.

src_unpack() {
	# Unpack tar files only.
	for f in ${A} ; do
		[[ ${f} == *".tar."* ]] && unpack ${f}
	done
}

src_prepare() {
	default
	if ! use binary; then
		mkdir "${WORKDIR}/${L_P}" || die
		cp -p "${DISTDIR}/${L_P}.jar" "${WORKDIR}/${L_P}/${L_PN}.jar" || die
		cat <<- EOF > "${WORKDIR}/${L_P}/sbt"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx3072M -Xss1M -XX:+CMSClassUnloadingEnabled"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${WORKDIR}/${L_P}/sbt-launch.jar" "\$@"
		EOF
		cat <<- EOF > "${S}/${P}"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx3072M -Xss1M -XX:+CMSClassUnloadingEnabled"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${S}/launch/target/sbt-launch.jar" "\$@"
		EOF
		chmod u+x "${WORKDIR}/${L_P}/sbt" "${S}/${P}" || die

		# suppress this warning in build.log:
		# [warn] Credentials file /var/tmp/portage/dev-java/${P}/work/.bintray/.credentials does not exist
		mkdir -p "${WORKDIR}/.bintray" || die
		cat <<- EOF > "${WORKDIR}/.bintray/.credentials"
			realm = Bintray API Realm
			host = api.bintray.com
			user =
			password =
		EOF
	fi
}

src_compile() {
	if ! use binary; then
		einfo "=== sbt compile ..."
		local vm_version="$(java-config -g PROVIDES_VERSION)"
		"${WORKDIR}/${L_P}/sbt" -Dsbt.log.noformat=true compile || die
		einfo "=== sbt publishLocal with jdk ${vm_version} ..."
		cat <<- EOF | "${WORKDIR}/${L_P}/sbt" -Dsbt.log.noformat=true || die
			set every javaVersionPrefix in javaVersionCheck := Some("${vm_version}")
			publishLocal
		EOF
	fi
}

src_test() {
	"${S}/${P}" -Dsbt.log.noformat=true test || die
}

src_install() {
	# Place sbt-launch.jar at the end of the CLASSPATH
	java-pkg_dojar $(find "${WORKDIR}"/.ivy2/local -name \*.jar -print | grep -v sbt-launch.jar) \
		$(find "${WORKDIR}"/.ivy2/local -name sbt-launch.jar -print)
	local ja="-Dsbt.version=${PV} -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"
	java-pkg_dolauncher sbt --jar sbt-launch.jar --java_args "${ja}"
}
