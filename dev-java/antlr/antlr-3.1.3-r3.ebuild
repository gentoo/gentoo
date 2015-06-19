# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/antlr/antlr-3.1.3-r3.ebuild,v 1.1 2013/09/03 21:01:33 tomwij Exp $

EAPI="2"
JAVA_PKG_IUSE="source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A parser generator for C++, C#, Java, and Python"
HOMEPAGE="http://www.antlr.org/"
# You need to generate v3 grammars so that boostrapping works
SRC_URI="http://www.antlr.org/download/${P}.tar.gz
	mirror://gentoo/${P}-generated.tar.bz2"
LICENSE="BSD"
SLOT="3"
KEYWORDS="amd64 ~arm ~ia64 ppc ppc64 x86 ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="gunit"

COMMON_DEPEND=">=dev-java/stringtemplate-3.2:0
	 >=dev-java/antlr-2.7.7:0[java]
	 gunit? ( dev-java/junit:4 )"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND="${RDEPEND}
	>=virtual/jdk-1.5"

java_prepare() {
	rm -v lib/*.jar lib/.*.jar || die
	rm -v runtime/ActionScript/project/lib/*.jar || die
	# We must bundle this as we can't depend on ourselves
	cp -v "${WORKDIR}"/*.java tool/src/main/antlr/org/antlr/grammar/v3 || die
	local version="${PV} $(date '+%B %d, %Y %T')"
	local propertyfile="tool/src/main/resources/org/antlr/antlr.properties"
	[[ $(egrep "^[^#]" ${propertyfile} | wc -l) != 1 ]] \
		&& die "Unknown property found"
	sed -i "s/^\(antlr.version\)=.*$/\1=${version}/" ${propertyfile} || die
}

antlr2() {
	java -cp $(java-pkg_getjars antlr) antlr.Tool "${@}" || die "antlr2 failed"
}

antlr3() {
	local cp="${S}/bootstrap:${S}/tool/src/main/resources/"
	java -cp "${cp}":$(java-pkg_getjars antlr,stringtemplate) \
		org.antlr.Tool "${@}" || die "building v3 grammars failed"
}

build_antlr() {
	cd "${S}"
	local dest="${1}"
	# runtime
	find runtime -name "*.java" > "${T}/sources" || die
	# tool
	find tool/src/main -name "*.java" >> "${T}/sources" || die
	ejavac -d "${dest}" -cp $(java-pkg_getjars antlr,stringtemplate) "@${T}/sources"
}

# Uses maven so let's just do things manully for now
# when bumping use jardiff and apicheck to make sure
# produced jars are good
src_compile() {
	einfo "Bootstrapping antlr3 with bundled sources"
	cd tool/src/main/antlr2/org/antlr/grammar/v2/ || die
	# the command line only takes one at a time
	for grammar in *.g; do
		antlr2 ${grammar} || die
	done

	cd "${S}" || die
	mkdir bootstrap || die
	build_antlr bootstrap

	einfo "Building v3 grammars with boostrapped antlr"
	local v3dir=tool/src/main/antlr/org/antlr/grammar/v3/
	rm -v "${v3dir}"/*.java || die
	antlr3 "${v3dir}"/*.g

	mkdir build || die
	cp -r "${S}"/tool/src/main/resources/* build || die
	build_antlr build

	if use gunit; then
		einfo "building gunit"
		antlr3 gunit/src/main/antlr3/org/antlr/gunit/*.g

		find gunit -name "*.java" > "${T}/gunit" || die
		ejavac -d build -cp $(java-pkg_getjars stringtemplate,junit-4):build \
			"@${T}/gunit"

		cp -vr gunit/src/main/resources/org build || die
	fi

	# jar things up
	cd build
	find -type f >> "${T}/classes" || die
	jar cf ${PN}3.jar "@${T}/classes" || die "jar failed"
}

src_install() {
	# Single jar like upstream
	java-pkg_dojar build/antlr3.jar
	java-pkg_dolauncher antlr3 --main org.antlr.Tool
	use gunit && java-pkg_dolauncher gunit --main org.antlr.gunit.Interp

	use source && java-pkg_dosrc tool/src/main/org \
		runtime/Java/src/main/java/org/
}

pkg_postinst() {
	elog "Currently the ebuild only has support for the Java backend."
}
