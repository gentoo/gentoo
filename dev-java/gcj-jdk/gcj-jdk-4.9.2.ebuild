# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-vm-2 multilib

DESCRIPTION="Java wrappers around GCJ"
HOMEPAGE="http://www.gentoo.org/"
SRC_URI=""

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86 ~x86-linux"
SLOT="0"
IUSE="X"

ECJ_GCJ_SLOT="4.4"
API_DIFF_PV="4.8.2"

# perl is needed for javac wrapper
RDEPEND="
	dev-java/ecj-gcj:${ECJ_GCJ_SLOT}
	dev-lang/perl
	~sys-devel/gcc-${PV}[gcj]
	X? ( ~sys-devel/gcc-${PV}[awt] )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	# jre lib paths ...
	local libarch="$(get_system_arch)"
	local gcc_version=${PV}
	local gccbin=$(gcc-config -B ${gcc_version})
	gccbin=${gccbin#"${EPREFIX}"}
	local gcclib=$(gcc-config -L ${gcc_version} | cut -d':' -f1)
	gcclib=${gcclib#"${EPREFIX}"}
	local gcjhome="/usr/$(get_libdir)/${P}"
	local gccchost="${CHOST}"
	local gcjlibdir=$(echo "${EPREFIX}"/usr/$(get_libdir)/gcj-${gcc_version}-*)
	gcjlibdir=${gcjlibdir#"${EPREFIX}"}

	# links
	dodir ${gcjhome}/bin
	dodir ${gcjhome}/jre/bin
	dosym ${gccbin}/gij ${gcjhome}/bin/java
	dosym ${gccbin}/gij ${gcjhome}/jre/bin/java
	dosym ${gccbin}/gjar ${gcjhome}/bin/jar
	dosym ${gccbin}/gjdoc ${gcjhome}/bin/javadoc
	dosym ${gccbin}/grmic ${gcjhome}/bin/rmic
	dosym ${gccbin}/gjavah ${gcjhome}/bin/javah
	dosym ${gccbin}/jcf-dump ${gcjhome}/bin/javap
	dosym ${gccbin}/gappletviewer ${gcjhome}/bin/appletviewer
	dosym ${gccbin}/gjarsigner ${gcjhome}/bin/jarsigner
	dosym ${gccbin}/grmiregistry ${gcjhome}/bin/rmiregistry
	dosym ${gccbin}/grmiregistry ${gcjhome}/jre/bin/rmiregistry
	dosym ${gccbin}/gkeytool ${gcjhome}/bin/keytool
	dosym ${gccbin}/gkeytool ${gcjhome}/jre/bin/keytool
	dosym ${gccbin}/gnative2ascii ${gcjhome}/bin/native2ascii
	dosym ${gccbin}/gorbd ${gcjhome}/bin/orbd
	dosym ${gccbin}/gorbd ${gcjhome}/jre/bin/orbd
	dosym ${gccbin}/grmid ${gcjhome}/bin/rmid
	dosym ${gccbin}/grmid ${gcjhome}/jre/bin/rmid
	dosym ${gccbin}/gserialver ${gcjhome}/bin/serialver
	dosym ${gccbin}/gtnameserv ${gcjhome}/bin/tnameserv
	dosym ${gccbin}/gtnameserv ${gcjhome}/jre/bin/tnameserv

	dodir ${gcjhome}/jre/lib/${libarch}/client
	dodir ${gcjhome}/jre/lib/${libarch}/server
	dosym ${gcjlibdir}/libjvm.so ${gcjhome}/jre/lib/${libarch}/client/libjvm.so
	dosym ${gcjlibdir}/libjvm.so ${gcjhome}/jre/lib/${libarch}/server/libjvm.so
	use X && dosym ${gcjlibdir}/libjawt.so ${gcjhome}/jre/lib/${libarch}/libjawt.so

	dosym /usr/share/gcc-data/${gccchost}/${gcc_version}/java/libgcj-${gcc_version/_/-}.jar \
		${gcjhome}/jre/lib/rt.jar
	dodir ${gcjhome}/lib
	dosym /usr/share/gcc-data/${gccchost}/${gcc_version}/java/libgcj-tools-${gcc_version/_/-}.jar \
		${gcjhome}/lib/tools.jar
	dosym ${gcclib}/include ${gcjhome}/include

	local ecj_jar="$(readlink "${EPREFIX}"/usr/share/eclipse-ecj/ecj.jar)"
	exeinto ${gcjhome}/bin
	sed -e "s#@JAVA@#${gcjhome}/bin/java#" \
		-e "s#@ECJ_JAR@#${ecj_jar}#" \
		-e "s#@RT_JAR@#${gcjhome}/jre/lib/rt.jar#" \
		-e "s#@TOOLS_JAR@#${gcjhome}/lib/tools.jar#" \
		"${FILESDIR}"/javac.in \
	| newexe - javac
	assert

	set_java_env
}

pkg_postinst() {
	# Do not set as system VM (see below)
	# java-vm-2_pkg_postinst

	ewarn "gcj does not currently provide all the 1.5 or 1.6 APIs."
	ewarn "See http://fuseyism.com/japi/ibmjdk15-libgcj-${API_DIFF_PV}.html"
	ewarn "and http://fuseyism.com/japi/icedtea6-libgcj-${API_DIFF_PV}.html"
	ewarn "Check for existing bugs relating to missing APIs and file"
	ewarn "new ones at http://gcc.gnu.org/bugzilla/"
	ewarn
	ewarn "Due to this and limited manpower, we currently cannot support"
	ewarn "using gcj-jdk as a system VM. Its main purpose is to bootstrap"
	ewarn "IcedTea without prior binary VM installation. To do that, execute:"
	ewarn
	ewarn "emerge -o icedtea && emerge icedtea"
}
