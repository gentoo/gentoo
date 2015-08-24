# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

# repoman gives LIVEVCS.unmasked even with EGIT_COMMIT, so create snapshot
inherit eutils java-pkg-2 # git-r3

L_PN="sbt-launch"
L_P="${L_PN}-${PV}"

B_PV="0.13.7"
BL_P="${L_PN}-${B_PV}"
B_P="${PN}-${B_PV}"

SV="2.10"

# creating the sbt src snapshot:
# git clone https://github.com/sbt/sbt.git sbt-0.13.8
# cd sbt-0.13.8
# git checkout v0.13.8
# cd ..
# tar --owner=portage --group=portage -cjf sbt-0.13.8-src.tar.bz2 sbt-0.13.8

# creating the binary:
# cd $WORDKIR
# tar -cjf sbt-0.13.8-gentoo-binary.tar.bz2 sbt-0.13.8/sbt-launch/target/sbt-launch.jar

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
	http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/${L_PN}/${PV}/${L_PN}.jar -> ${BL_P}.jar
)
binary? ( https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.bz2 )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="binary"

DEPEND="virtual/jdk:1.6
	>=dev-lang/scala-2.10.4-r1:${SV}"
RDEPEND=">=virtual/jre-1.6
	dev-lang/scala:*"

# test hangs or fails
RESTRICT="test"

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
		# Note: to bump sbt, some things to try are:
		# 1. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.bz2
		# https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.bz2 and
		# https://dev.gentoo.org/~gienah/snapshots/${P}-test-deps.tar.bz2 from SRC_URI
		# 2. Comment the sbt publishLocal line in src_compile.
		# 3. try:
		# FEATURES='noclean -test' emerge -v dev-java/sbt
		# It should fail in src_install since the sbt publishLocal is not done.
		# Check if it downloads more stuff in
		# src_compile to ${WORKDIR}/.ivy2 and ${WORKDIR}/.sbt.
		# 4. If some of the downloads fail, it might be necessary to run the sbt compile
		# again manually to obtain all the dependencies, if so (with jdk 1.6):
		# cd to ${S}
		# export EROOT=/
		# export WORKDIR='/var/tmp/portage/dev-java/sbt-0.13.8/work'
		# export SV="2.10"
		# export B_P=sbt-0.13.7
		# export PATH="/usr/share/scala-${SV}/bin:${WORKDIR}/${B_P}:${PATH}"
		# sbt compile
		# cd ${WORKDIR}
		# find .ivy2 .sbt -uid 0 -exec chown portage:portage {} \;
		# 5. cd ${WORKDIR}
		# tar -cjf sbt-0.13.8-ivy2-deps.tar.bz2 .ivy2
		# tar -cjf sbt-0.13.8-sbt-deps.tar.bz2 .sbt
		# 6. It downloads more dependencies for src_test, however the presence of some of these may cause
		# the src_compile to fail.  So download them seperately as root so we can identify the
		# additional files.  Note: src_test creates some files in ${WORKDIR}/.m2 which are can
		# hopefully be ignored. As root:
		# cd ${S}
		# sbt test
		# cd ${WORKDIR}
		# find .ivy2 .sbt -uid 0 -print
		# Then add those files to sbt-0.13.8-ivy2-test-deps.tar.bz2 except the files in the directories
		# .ivy2/local
		# .ivy2/cache/org.scala-sbt
		# Something like:
		# tar --owner=portage --group=portage -cjf sbt-0.13.8-test-deps.tar.bz2 <list of files as described above>
		# 7. Undo the earlier temporary edits to the ebuild.

		mkdir "${WORKDIR}/${B_P}" || die
		cp -p "${DISTDIR}/${BL_P}.jar" "${WORKDIR}/${B_P}/${L_PN}.jar" || die
		cat <<- EOF > "${WORKDIR}/${B_P}/sbt"
			#!/bin/sh
			SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
			java -Djavac.args="-encoding UTF-8" -Duser.home="${WORKDIR}" \${SBT_OPTS} -jar "${WORKDIR}/${B_P}/sbt-launch.jar" "\$@"
		EOF
		chmod u+x "${WORKDIR}/${B_P}/sbt" || die
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
		"${WORKDIR}/${B_P}/sbt" -Dsbt.log.noformat=true publishLocal || die
	fi
}

src_test() {
	if ! use binary; then
		export PATH="${EROOT}usr/share/scala-${SV}/bin:${WORKDIR}/${B_P}:${PATH}"
		"${WORKDIR}/${B_P}/sbt" -Dsbt.log.noformat=true test || die
	fi
}

src_install() {
	if ! use binary; then
		pushd sbt-launch/target || die
		mv ${L_P}.jar ${L_PN}.jar || die
		popd
	fi
	java-pkg_dojar sbt-launch/target/${L_PN}.jar
	java-pkg_dolauncher sbt --main xsbt.boot.Boot --java_args "-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -XX:MaxPermSize=512M"
}
