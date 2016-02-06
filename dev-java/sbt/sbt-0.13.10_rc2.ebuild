# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# repoman gives LIVEVCS.unmasked even with EGIT_COMMIT, so create snapshot
inherit eutils java-pkg-2 # git-r3

MY_PV="0.13.10-RC2"

L_PN="sbt-launch"
L_P="${L_PN}-${MY_PV}"

B_PV="0.13.9"
BL_P="${L_PN}-${B_PV}"
B_P="${PN}-${B_PV}"

SV="2.10"

DESCRIPTION="sbt is a build tool for Scala and Java projects that aims to do the basics well"
HOMEPAGE="http://www.scala-sbt.org/"
EGIT_COMMIT="v${PV}"
EGIT_REPO_URI="https://github.com/sbt/sbt.git"
SRC_URI="!binary?
(
	https://dev.gentoo.org/~gienah/snapshots/${P}-src.tar.bz2
	https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.bz2
	https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.bz2
	https://dev.gentoo.org/~gienah/snapshots/${P}-test-deps.tar.bz2
	http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/${L_PN}/${MY_PV}/${L_PN}.jar -> ${BL_P}.jar
)
binary? ( https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.bz2 )
"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="binary"

DEPEND="virtual/jdk:1.7
	>=dev-lang/scala-2.10.6:${SV}"
RDEPEND="|| ( virtual/jre:1.7 virtual/jre:1.8 )
	dev-lang/scala:*"

# test hangs or fails
RESTRICT="test"

# Note: to bump sbt, some things to try are:
# 1. Create the sbt src snapshot:
# git clone https://github.com/sbt/sbt.git sbt-0.13.10_rc2
# cd sbt-0.13.10_rc2
# git checkout v0.13.10-RC2
# cd ..
# tar --owner=portage --group=portage -cjf /usr/portage/distfiles/sbt-0.13.10_rc2-src.tar.bz2 \
# sbt-0.13.10_rc2
# 2. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.bz2
# https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.bz2 and
# https://dev.gentoo.org/~gienah/snapshots/${P}-test-deps.tar.bz2
# binary? ( https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.bz2 )
# from SRC_URI
# 3. Comment the sbt publishLocal line in src_compile.
# 4. try:
# FEATURES='noclean -test' emerge -v -1 dev-java/sbt
# It should fail in src_install since the sbt publishLocal is not done.
# Check if it downloads more stuff in
# src_compile to ${WORKDIR}/.ivy2 and ${WORKDIR}/.sbt.
# 5. If some of the downloads fail, it might be necessary to run the sbt compile
# again manually to obtain all the dependencies, if so (with jdk 1.6):
# cd to ${S}
# export EROOT=/
# export WORKDIR='/var/tmp/portage/dev-java/sbt-0.13.10_rc2/work'
# export SV="2.10"
# export B_P=sbt-0.13.10_rc2
# export PATH="/usr/share/scala-${SV}/bin:${WORKDIR}/${B_P}:${PATH}"
# sbt compile
# cd ${WORKDIR}
# find .ivy2 .sbt -uid 0 -exec chown portage:portage {} \;
# 6. cd ${WORKDIR}
# tar -cjf /usr/portage/distfiles/sbt-0.13.10_rc2-ivy2-deps.tar.bz2 .ivy2
# tar -cjf /usr/portage/distfiles/sbt-0.13.10_rc2-sbt-deps.tar.bz2 .sbt
# Uncomment the sbt publishLocal line in src_compile.
# 7. It downloads more dependencies for src_test, however the presence of some of these may cause
# the src_compile to fail.  So download them seperately as root so we can identify the
# additional files.  Note: src_test creates some files in ${WORKDIR}/.m2 which are can
# hopefully be ignored. As root:
# cd ${S}
# ${S}/sbt-0.13.10_rc2 test
# cd ${WORKDIR}
# tar --owner=portage --group=portage -cjf /usr/portage/distfiles/sbt-0.13.10_rc2-test-deps.tar.bz2 \
# $(find .ivy2 .sbt -uid 0 -type f -print)
# 8. Create the binary
# cd $WORDKIR
# tar --owner=portage --group=portage -cjf /usr/portage/distfiles/sbt-0.13.10_rc2-gentoo-binary.tar.bz2 \
# sbt-0.13.10_rc2 .ivy2/local
# 9. Undo the earlier temporary edits to the ebuild.

src_unpack() {
	# if ! use binary; then
	# 	git-r3_src_unpack
	# fi
	# Unpack tar files only.
	for f in ${A} ; do
		[[ ${f} == *".tar."* ]] && unpack ${f}
	done
}

java_prepare() {
	if ! use binary; then
		mkdir "${WORKDIR}/${B_P}" || die
		cp -p "${DISTDIR}/${BL_P}.jar" "${WORKDIR}/${B_P}/${L_PN}.jar" || die
		cat <<- EOF > "${WORKDIR}/${B_P}/sbt"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${WORKDIR}/${B_P}/sbt-launch.jar" "\$@"
		EOF
		cat <<- EOF > "${S}/${P}"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${S}/launch/target/sbt-launch.jar" "\$@"
		EOF
		chmod u+x "${WORKDIR}/${B_P}/sbt" "${S}/${P}" || die
		local SCALA_PVR="$(java-config --query=PVR --package=scala-${SV})"
		local SFV="${SCALA_PVR/-*}"
		sed -e "s@scalaVersion := \"2.10.4\",@scalaVersion := \"${SFV}\",\n  scalaHome := Some(file(\"/usr/share/scala-${SV}\")),@" \
			-i "${S}/build.sbt" || die
	fi
}

src_compile() {
	if ! use binary; then
		export PATH="${EROOT}usr/share/scala-${SV}/bin:${WORKDIR}/${B_P}:${PATH}"
		einfo "=== sbt compile ..."
		"${WORKDIR}/${B_P}/sbt" -Dsbt.log.noformat=true compile || die
		einfo "=== sbt publishLocal ..."
		cat <<- EOF | "${WORKDIR}/${B_P}/sbt" -Dsbt.log.noformat=true || die
			set every javaVersionPrefix in javaVersionCheck := Some("1.7")
			publishLocal
		EOF
	fi
}

src_test() {
	if ! use binary; then
		export PATH="${EROOT}usr/share/scala-${SV}/bin:${S}:${PATH}"
		"${S}/${P}" -Dsbt.log.noformat=true test || die
	fi
}

src_install() {
	# Place sbt-launch.jar at the end of the CLASSPATH
	java-pkg_dojar $(find "${WORKDIR}"/.ivy2/local -name \*.jar -print | grep -v sbt-launch.jar) \
				   $(find "${WORKDIR}"/.ivy2/local -name sbt-launch.jar -print)
	java-pkg_dolauncher sbt --jar sbt-launch.jar --java_args "-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
}
