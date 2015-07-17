# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/freemind/freemind-1.0.1-r2.ebuild,v 1.1 2015/07/17 13:01:29 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Mind-mapping software written in Java"
HOMEPAGE="http://freemind.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="groovy latex pdf svg"

CDEPEND="
	dev-java/javahelp:0
	dev-java/jgoodies-forms:0
	dev-java/jibx:0
	dev-java/jortho:0
	>=dev-java/simplyhtml-0.13.1:0
	groovy? ( dev-java/groovy )
	latex? ( dev-java/hoteqn:0 )
	pdf? (
		dev-java/batik:1.8
		dev-java/fop:2
	)
	svg? (
		dev-java/batik:1.8
		dev-java/fop:0
	)"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	pdf? ( dev-java/avalon-framework:4.2 )
	svg? ( dev-java/avalon-framework:4.2 )"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

S="${WORKDIR}/${PN}"

java_prepare() {
	chmod +x check_for_duplicate_resources.sh || die

	# someone got it all wrong (set/unset vs. bool)
	sed -i -e 's|<property name="include_latex" value="false"/>||' plugins/build.xml || die

	# disable dmg build on Mac OS X
	sed -i -e 's:<antcall target="dist_\(macos\|icon\)"/>::p' 'build.xml' || die

	use groovy || rm plugins/build_scripting.xml || die
	use latex || rm plugins/build_latex.xml || die
	use pdf || use svg || rm plugins/build_svg.xml || die
	# not compatible with releases of jmapviewer
	rm plugins/build_map.xml || die

	rm -v $(find "${WORKDIR}" -name '*.jar' -o -name '*.zip') || die
}

src_configure() {
	local build_files=( $(find "${S}" -name 'build*.xml') )
	JAVA_PKG_BSFIX_NAME="${build_files[@]##*/}"
	JAVA_ANT_REWRITE_CLASSPATH="yes"
	JAVA_ANT_CLASSPATH_TAGS+=" javadoc"
	JAVA_ANT_ENCODING="utf-8"
	java-ant-2_src_configure
}

src_compile() {
	local svg_deps svg_build_deps
	if use pdf || use svg; then
		svg_deps="batik-1.8,fop-2"
		svg_build_deps=":$(java-pkg_getjars --build-only avalon-framework-4.2)"
	fi
	EANT_GENTOO_CLASSPATH="
		jgoodies-forms,jibx,javahelp,jortho,simplyhtml
		$(usex groovy groovy '')
		$(usex latex hoteqn '')
		${svg_deps}"
	EANT_GENTOO_CLASSPATH_EXTRA="lib/bindings.jar${svg_build_deps}"
	EANT_BUILD_TARGET="dist"
	EANT_DOC_TARGET="doc"
	EANT_ANT_TASKS="jibx"
	java-pkg-2_src_compile
}

src_install() {
	cd "${WORKDIR}"/bin/dist || die
	local dest="/usr/share/${PN}/"

	java-pkg_dojar lib/*.jar

	if use doc; then
		java-pkg_dojavadoc doc/javadoc
		rm -r doc/javadoc
	fi

	insinto "${dest}"
	doins -r accessories browser doc plugins patterns.xml

	# register plugins for java-dep-check
	local plugins="help"
	use groovy && plugins+=" script"
	use latex && plugins+=" latex"
	if use pdf || use svg; then
		plugins+=" svg"
	fi
	local plugin
	for plugin in ${plugins}; do
		java-pkg_regjar "${ED}"${dest}/plugins/${plugin}/*jar
	done

	java-pkg_dolauncher ${PN} --java_args "-Dfreemind.base.dir=${EPREFIX}${dest}" \
		--pwd "${EPREFIX}${dest}" --main freemind.main.FreeMindStarter

	newicon "${S}/images/FreeMindWindowIcon.png" freemind.png

	make_desktop_entry freemind Freemind freemind Utility
}
