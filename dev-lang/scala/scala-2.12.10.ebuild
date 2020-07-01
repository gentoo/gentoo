# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

JAVA_PKG_IUSE="doc source"

inherit eutils check-reqs java-pkg-2

SV="$(ver_cut 1-2)"
SBTV="0.13.18"

# Note: to bump scala, some things to try are:
# 1. remove the https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.gz
# and https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.gz from
# SRC_URI
# 2. try emerge scala, with network-sandbox disabled:
# FEATURES="noclean -network-sandbox" emerge dev-lang/scala
# Check if it downloads more stuff in src_compile to
# ${WORKDIR}/.ivy2 or ${WORKDIR}/.sbt or /root/.ivy2 or /root/.sbt
# 3. tar up all the .ivy2 and .sbt junk into ${P}-ivy2-deps.tar.xz and
# ${P}-sbt-deps.tar.xz and add them to SRC_URI, in ${WORKDIR}:
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-ivy2-deps.tar.xz .ivy2/cache
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-sbt-deps.tar.xz .sbt
# 4. Add these tar files to SRC_URI (undo step 1).
# 5. Try emerging it again, with network-sandbox, and create the bianry
# tar archive:
# FEATURES="noclean network-sandbox -test" USE="doc source" emerge dev-lang/scala
# cd $WORDKIR
# XZ_OPT=-9 tar --owner=portage --group=portage \
# -cJf /usr/portage/distfiles/${P}-gentoo-binary.tar.xz .ivy2/local \
# ${P}/build/pack/bin ${P}/build/quick/classes/scala-dist/man/man1 \
# ${P}/src/library ${P}/src/library-aux ${P}/src/reflect ${P}/doc/README \
# ${P}/build/scaladoc

DESCRIPTION="The Scala Programming Language"
HOMEPAGE="https://www.scala-lang.org/"
SRC_URI="
	!binary?  (
		https://github.com/scala/scala/archive/v${PV}.tar.gz -> ${P}.tar.gz
		https://dev.gentoo.org/~gienah/snapshots/${P}-ivy2-deps.tar.xz
		https://dev.gentoo.org/~gienah/snapshots/${P}-sbt-deps.tar.xz
	)
	binary? (
		https://dev.gentoo.org/~gienah/files/dist/${P}-gentoo-binary.tar.xz
	)"
LICENSE="BSD"
SLOT="${SV}/${PV}"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

IUSE="binary emacs"

COMMON_DEP="dev-java/ant-core:0
	dev-java/jline:2"

DEPEND="${COMMON_DEP}
	!binary? (
		>=virtual/jdk-1.8:*
		>=dev-java/sbt-${SBTV}:0
		media-gfx/graphviz
	)
	binary? (
		>=virtual/jdk-1.8:*
	)
	app-arch/xz-utils:0"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.8:*
	app-eselect/eselect-scala
	!dev-lang/scala-bin:0"

PDEPEND="emacs? ( app-emacs/scala-mode:0 )"

CHECKREQS_MEMORY="1536M"

pkg_setup() {
	java-pkg-2_pkg_setup

	if ! use binary; then
		debug-print "Checking for sufficient physical RAM"

		ewarn "This package can fail to build with memory allocation errors in some cases."
		ewarn "If you are unable to build from sources, please try USE=binary"
		ewarn "for this package. See bug #181390 for more information."

		check-reqs_pkg_setup
	fi
}

pkg_pretend() {
	if ! use binary; then
		check-reqs_pkg_pretend
	fi
}

src_unpack() {
	# Unpack tar files only.
	for f in ${A} ; do
		[[ ${f} == *".tar."* ]] && unpack ${f}
	done
}

src_prepare() {
	java-pkg_getjars ant-core,jline-2,sbt

	if ! use binary; then
		local a
		for a in "${JURI[@]}"
		do
			echo "${a}"
			local g="${a/* -> /}"
			echo "${g}"
			local j="${a/ -> */}"
			echo "${j}"
			cp -p "${DISTDIR}/${g}" "${S}/${j#${BURI}/*/}" || die
		done

		# gentoo patch (by gienah) to stop it calling git log in the build
		eapply "${FILESDIR}/${PN}-2.12.10-no-git.patch"

		local SBT_PVR="$(java-config --query=PVR --package=sbt)"
		sed -e "s@sbt.version=${SBTV}@sbt.version=${SBT_PVR}@" \
			-i "${S}/project/build.properties" \
			|| die "Could not set sbt.version=${SBT_PVR} in project/build.properties"

		cat <<- EOF > "${S}/sbt"
			#!/bin/bash
			gjl_package=sbt
			gjl_jar="sbt-launch.jar"
			gjl_java_args="-Dsbt.version=${SBT_PVR} -Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled -Duser.home="${WORKDIR}""
			source /usr/share/java-config-2/launcher/launcher.bash
		EOF
		chmod u+x "${S}/sbt" || die

		sed -e 's@-Xmx1024M@-Xmx1536M@' \
			-i "${S}/build.sbt" \
			|| die "Could not change increase memory size in ${S}/build.sbt"
	fi

	default
}

src_compile() {
	if ! use binary; then
		export PATH="${EROOT}/usr/share/scala-${SV}/bin:${WORKDIR}/${L_P}:${PATH}"
		export LANG="en_US.UTF-8"
		einfo "=== scala compile ..."
		"${S}"/sbt -Dsbt.log.noformat=true compile || die "sbt compile failed"
		einfo "=== sbt publishLocal with jdk $(java-pkg_get-vm-version) ..."
		"${S}"/sbt -Dsbt.log.noformat=true publishLocal \
			|| die "sbt publishLocal failed"
	else
		einfo "Skipping compilation, USE=binary is set."
	fi
}

src_test() {
	if ! use binary; then
		"${S}"/sbt -Dsbt.log.noformat=true test || die "sbt test failed"
	else
		einfo "Skipping tests, USE=binary is set."
	fi
}

src_install() {
	pushd build/pack || die
	local SCALADIR="/usr/share/${PN}-${SV}"
	exeinto "${SCALADIR}/bin"
	doexe $(find bin/ -type f ! -iname '*.bat')
	dodir /usr/bin
	for b in $(find bin/ -type f ! -iname '*.bat'); do
		local _name=$(basename "${b}")
		dosym "${SCALADIR}/bin/${_name}" "/usr/bin/${_name}-${SV}"
	done
	popd || die
	java-pkg_dojar $(find "${WORKDIR}"/.ivy2/local -name \*.jar -print)

	pushd build/quick/classes/scala-dist/man/man1 || die
	for i in *.1; do
		newman "${i}" "${i/./-${SV}.}"
	done
	popd || die

	#sources are .scala so no use for java-pkg_dosrc
	pushd src || die
	if use source; then
		dodir "${SCALADIR}/src"
		insinto "${SCALADIR}/src"
		doins -r library library-aux reflect
	fi
	popd || die

	local DOCS=( "doc/README" )
	local HTML_DOCS=( "build/scaladoc" )
	use doc && einstalldocs
}
