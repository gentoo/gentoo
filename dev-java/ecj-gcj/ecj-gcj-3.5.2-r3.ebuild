# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit java-pkg-2 prefix toolchain-funcs

MY_PN="ecj"
DMF="R-${PV}-201002111343"

DESCRIPTION="A subset of Eclipse Compiler for Java compiled by gcj, serving as javac in gcj-jdk"
HOMEPAGE="http://www.eclipse.org/"
SRC_URI="http://download.eclipse.org/eclipse/downloads/drops/${DMF}/${MY_PN}src-${PV}.zip"

LICENSE="EPL-1.0"
SLOT="3.5"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="+native"

RDEPEND="sys-devel/gcc:*[gcj]
	app-eselect/eselect-java"
DEPEND="${RDEPEND}
	app-arch/unzip
	!dev-java/eclipse-ecj:3.5[gcj]"

S="${WORKDIR}"

# for compatibility with java eclass functions
JAVA_PKG_WANT_SOURCE=1.4
JAVA_PKG_WANT_TARGET=1.4

MY_PS="${MY_PN}-${SLOT}"

java_prepare() {
	# We don't need the ant adapter here
	rm -f org/eclipse/jdt/core/JDTCompilerAdapter.java || die
	rm -fr org/eclipse/jdt/internal/antadapter || die

	# upstream build.xml excludes this
	rm -f META-INF/eclipse.inf || die

	# these java6 specific classes cannot compile with ecj
	rm -fr org/eclipse/jdt/internal/compiler/{apt,tool}/ || die
}

src_compile() {
	local javac_opts javac java jar

	local gccbin=$(gcc-config -B)
	local gccver=$(gcc-fullversion)

	local gcj="${gccbin}/gcj"
	javac="${gcj} -C --encoding=ISO-8859-1"
	jar="${gccbin}/gjar"
	java="${gccbin}/gij"

	mkdir -p bootstrap || die
	cp -pPR org bootstrap || die
	cd "${S}/bootstrap" || die

	einfo "bootstrapping ${MY_PN} with ${javac} ..."
	${javac} ${javac_opts} $(find org/ -name '*.java') || die
	find org/ \( -name '*.class' -o -name '*.properties' -o -name '*.rsc' \) \
		-exec ${jar} cf ${MY_PN}.jar {} + || die

	cd "${S}" || die

	einfo "building ${MY_PN} with bootstrapped ${MY_PN} ..."
	${java} -classpath bootstrap/${MY_PN}.jar \
		org.eclipse.jdt.internal.compiler.batch.Main \
		${javac_opts} -nowarn org || die
	find org/ \( -name '*.class' -o -name '*.properties' -o -name '*.rsc' \) \
		-exec ${jar} cf ${MY_PN}.jar {} + || die

	if use native; then
		einfo "Building native ${MY_PS} library, patience needed ..."
		${gcj} ${CFLAGS} ${LDFLAGS} -findirect-dispatch -shared -fPIC -Wl,-Bsymbolic \
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
		$(gcc-config -B)/gcj-dbtool -a $(gcj-dbtool -p) \
			"${EPREFIX}"/usr/share/${PN}-${SLOT}/lib/ecj.jar \
			"${EPREFIX}"/usr/$(get_libdir)/${MY_PN}-${SLOT}.so
	fi

	einfo "To select between slots of ECJ..."
	einfo " # eselect ecj"

	eselect ecj update ${PN}-${SLOT}
}

pkg_postrm() {
	eselect ecj update
}
