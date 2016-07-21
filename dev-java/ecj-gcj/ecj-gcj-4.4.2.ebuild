# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 prefix toolchain-funcs

MY_PN="ecj"
DMF="R-${PV}-201502041700"

DESCRIPTION="A subset of Eclipse Compiler for Java compiled by gcj, serving as javac in gcj-jdk"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops4/${DMF}/${MY_PN}src-${PV}.jar"

LICENSE="EPL-1.0"
SLOT="4.4"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="+native"

RDEPEND="sys-devel/gcc:*[gcj]
	app-eselect/eselect-java"
DEPEND="${RDEPEND}
	app-arch/unzip
	!dev-java/eclipse-ecj:3.5[gcj]"

JAVA_PKG_WANT_SOURCE=1.6
JAVA_PKG_WANT_TARGET=1.6

MY_PS="${MY_PN}-${SLOT}"
S="${WORKDIR}"

java_prepare() {
	# We don't need the ant adapter here
	rm org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -r org/eclipse/jdt/internal/antadapter || die

	# upstream build.xml excludes this
	rm META-INF/eclipse.inf || die

	# these java6 specific classes cannot compile with gcj
	rm -r org/eclipse/jdt/internal/compiler/{apt,tool}/ || die
}

src_compile() {
	local gccbin=$(gcc-config -B)
	local gcj="${gccbin}/gcj"

	find org/ -name "*.java" > sources.lst || die

	einfo "bootstrapping ${MY_PN} with gcj ..."
	"${gcj}" -w -C -fsource=${JAVA_PKG_WANT_SOURCE} -d bootstrap @sources.lst || die

	einfo "building ${MY_PN} with bootstrapped ${MY_PN} ..."
	"${gccbin}/gij" -cp bootstrap:. org.eclipse.jdt.internal.compiler.batch.Main -nowarn $(java-pkg_javac-args) @sources.lst || die
	find org/ META-INF/ -type f ! -name "*.java" -exec "${gccbin}/gjar" cf ${MY_PN}.jar {} + || die

	if use native; then
		einfo "building native ${MY_PS} library, patience needed ..."
		"${gcj}" ${CFLAGS} ${LDFLAGS} -findirect-dispatch -shared -fPIC -Wl,-Bsymbolic \
			-o ${MY_PS}.so ${MY_PN}.jar || die
	fi
}

src_install() {
	java-pkg_dojar ${MY_PN}.jar

	sed -e "s|@SLOT@|${SLOT}|" \
		"${FILESDIR}/${PN}.in" \
		> "${T}"/${PN}-${SLOT} || die
	eprefixify "${T}/${PN}-${SLOT}"
	dobin  "${T}/${PN}-${SLOT}"

	use native && dolib.so ${MY_PS}.so
}

pkg_postinst() {
	if use native; then
		local dbtool="$(gcc-config -B)/gcj-dbtool"

		"${dbtool}" -a $("${dbtool}" -p) \
			"${EROOT}usr/share/${PN}-${SLOT}/lib/ecj.jar" \
			"${EROOT}usr/$(get_libdir)/${MY_PN}-${SLOT}.so"
	fi

	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ${PN}-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
