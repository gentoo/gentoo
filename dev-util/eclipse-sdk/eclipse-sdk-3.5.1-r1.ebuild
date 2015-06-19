# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eclipse-sdk/eclipse-sdk-3.5.1-r1.ebuild,v 1.6 2012/05/21 20:05:07 ssuominen Exp $

EAPI="2"
WANT_ANT_TASKS="ant-nodeps"

# eclipse-build is too complicated for automatic fixing
# if there are any fixes we should create patches
# and push them upstream
JAVA_PKG_BSFIX="off"

inherit eutils java-pkg-2 java-ant-2 check-reqs

BUILD_ID="R3_5_1"
ECLIPSE_BUILD_VER="R0_4_0"
S="${WORKDIR}/eclipse-build-${ECLIPSE_BUILD_VER}"

DESCRIPTION="Eclipse SDK"
HOMEPAGE="http://www.eclipse.org/eclipse/"
SRC_URI="http://download.eclipse.org/technology/linuxtools/eclipse-build/eclipse-${BUILD_ID}-fetched-src.tar.bz2
	http://download.eclipse.org/technology/linuxtools/eclipse-build/eclipse-build-${ECLIPSE_BUILD_VER}.tar.gz"

LICENSE="EPL-1.0"
SLOT="3.5"
KEYWORDS="amd64 x86"
IUSE="doc gnome source"

CDEPEND=">=dev-java/swt-${PV}:${SLOT}
	>=dev-java/ant-1.7.1
	>=dev-java/ant-core-1.7.1
	>=dev-java/asm-3.1:3
	>=dev-java/commons-codec-1.3
	>=dev-java/commons-el-1.0
	>=dev-java/commons-httpclient-3.1:3
	>=dev-java/commons-logging-1.0.4
	>=dev-java/hamcrest-core-1.1
	>=dev-java/icu4j-4.0.1:4
	>=dev-java/jsch-0.1.41
	>=dev-java/junit-3.8.2:0
	>=dev-java/junit-4.5:4
	>=dev-java/lucene-1.9.1:1.9
	>=dev-java/lucene-analyzers-1.9.1:1.9
	>=dev-java/sat4j-core-2.1:2
	>=dev-java/sat4j-pseudo-2.1:2
	dev-java/tomcat-servlet-api:2.5
	x86? ( gnome? ( gnome-base/gconf ) )
	dev-java/ant-nodeps"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	app-arch/unzip
	app-arch/zip
	>=virtual/jdk-1.6"

ALL_OS='aix hpux linux macosx qnx solaris win32'
ALL_WS='carbon cocoa gtk motif photon win32 wpf'
ALL_ARCH='alpha arm ia64 mips mipsel PA_RISC ppc ppc64 s390 s390x sparc sparc64 x86 x86_64'

buildDir="${S}/build/eclipse-${BUILD_ID}-fetched-src"

pkg_setup() {
	ws='gtk'
	if use x86 ; then os='linux' ; arch='x86'
	elif use amd64 ; then os='linux' ; arch='x86_64'
	fi

	java-pkg-2_pkg_setup

	if use doc ; then
		ewarn "Having the 'doc' USE flag enabled greatly increases the build time."
		ewarn "You might want to disable it for ${PN} if you don't need it."
	fi
}

src_unpack() {
	CHECKREQS_MEMORY="1536"
	if use doc || use source ; then
		CHECKREQS_DISK_BUILD="3072"
	else
		CHECKREQS_DISK_BUILD="1536"
	fi
	check_reqs

	unpack "eclipse-build-${ECLIPSE_BUILD_VER}.tar.gz"
	mv "${WORKDIR}/eclipse-build-0_4_RC6" "${S}" || die
	ln -s "${DISTDIR}/eclipse-${BUILD_ID}-fetched-src.tar.bz2" "${S}"/ || die

	cd "${S}"
	# building with ecj fails for some reason (polluted classpath probably)
	java-pkg_force-compiler javac
	eant unpack
}

src_prepare() {
	epatch "${FILESDIR}/3.5/jvmarg.patch" || die

	# apply patches before we start cleaning junk out
	eant applyPatches

	# fix up hardcoded runtime class paths
	sed -e 's|/usr/lib/jvm/java/jre/lib/rt\.jar:.*$|'"$(java-config --runtime)"'|' \
			-i {,pde}build.properties || die

	# fix up arch specifications if we're x86_64
	if use amd64 ; then
		sed -e 's/x86/\0_64/' -i "${buildDir}"/buildConfigs/eclipse-build-config/build.properties || die
	fi

	# disable building of libgnomeproxy on x86 if USE=-gnome
	if ! use gnome ; then
		sed_xml_element 'condition' -e '/property="build\.libgnomeproxy"/d' -i build.xml || die
	fi

	# skip compilation of SWT native libraries (we use the system-installed copies)
	sed_xml_element 'ant' -e '/swt/d' -i build.xml || die

	ebegin 'Removing plugins of irrelevant platforms'
	local remove_os=" ${ALL_OS} " ; remove_os=${remove_os/ ${os} / }
	remove_os=${remove_os# } ; remove_os=${remove_os% } ; remove_os=${remove_os// /'\|'}
	local remove_ws=" ${ALL_WS} " ; remove_ws=${remove_ws/ ${ws} / }
	remove_ws=${remove_ws# } ; remove_ws=${remove_ws% } ; remove_ws=${remove_ws// /'\|'}
	local remove_arch=" ${ALL_ARCH} " ; remove_arch=${remove_arch/ ${arch} / }
	remove_arch=${remove_arch# } ; remove_arch=${remove_arch% } ; remove_arch=${remove_arch// /'\|'}
	sed_xml_element 'includes\|plugin' \
			-e '/id="org\.eclipse\.\(core\.net\.linux\.x86\|update\.core\.linux\)"/b' \
			-e '/os="'"${remove_os}"'"/d' -e '/ws="'"${remove_ws}"'"/d' -e '/arch="'"${remove_arch}"'"/d' \
			-i "${buildDir}"/features/*/feature.xml "${S}"/eclipse-build-feature/feature.xml \
		|| die 'remove irrelevant platforms failed'
	eend

	if ! use doc ; then
		ebegin 'Removing documentation plugins'
		rm -rf "${buildDir}"/plugins/*.doc{,.*}
		eclipse_delete-plugins '.*\.doc\(\..*\|\)'
		eend
	fi

	if ! use source ; then
		ebegin 'Removing source plugins'
		rm -rf "${buildDir}"/plugins/*.source{,_*}
		eclipse_delete-plugins '.*\.source'
		eend
	fi

	unbundle "${buildDir}"/plugins
	cd ${buildDir} || die
	epatch "${FILESDIR}/${SLOT}/hamcrest-junit-lib.patch"
	epatch "${FILESDIR}/${SLOT}/gtk_makefile.patch"
}

src_compile() {
	ANT_OPTS='-Xmx512M' eant -DbuildArch=${arch}
}

src_install() {
	local destDir="/usr/$(get_libdir)/eclipse-${SLOT}"

	insinto "${destDir}"
	shopt -s dotglob
	doins -r "${buildDir}"/installation/* || die
	shopt -u dotglob
	chmod +x "${D}${destDir}"/eclipse
	rm -f "${D}${destDir}"/libcairo-swt.so  # use the system-installed SWT libraries

	ebegin 'Unbundling dependencies'
	unbundle "${D}${destDir}"
	eend

	# Install Gentoo wrapper and config
	dobin "${FILESDIR}/${SLOT}/eclipse-${SLOT}" || die
	insinto /etc
	doins "${FILESDIR}/${SLOT}/eclipserc-${SLOT}" || die

	# Create desktop entry
	make_desktop_entry "eclipse-${SLOT}" "Eclipse ${PV}" "${destDir}/icon.xpm" || die
}

unbundle() {
	pushd "${1}" > /dev/null || die
	eclipse_unbundle-dir plugins/org.apache.ant_* ant-core,ant-nodeps lib
	eclipse_unbundle-dir plugins/org.junit_* junit
	eclipse_unbundle-dir plugins/org.junit4_* junit-4
	eclipse_unbundle-jar plugins/com.ibm.icu_*.jar icu4j-4
	eclipse_unbundle-jar plugins/com.jcraft.jsch_*.jar jsch
	eclipse_unbundle-jar plugins/javax.servlet_*.jar tomcat-servlet-api-2.5 servlet-api
	eclipse_unbundle-jar plugins/javax.servlet.jsp_*.jar tomcat-servlet-api-2.5 jsp-api
	eclipse_unbundle-jar plugins/org.apache.commons.codec_*.jar commons-codec
	eclipse_unbundle-jar plugins/org.apache.commons.el_*.jar commons-el
	eclipse_unbundle-jar plugins/org.apache.commons.httpclient_*.jar commons-httpclient-3
	eclipse_unbundle-jar plugins/org.apache.commons.logging_*.jar commons-logging
	#eclipse_unbundle-jar plugins/org.apache.jasper_*.jar tomcat-jasper
	eclipse_unbundle-jar plugins/org.apache.lucene_*.jar lucene-1.9
	eclipse_unbundle-jar plugins/org.apache.lucene.analysis_*.jar lucene-analyzers-1.9
	eclipse_unbundle-jar plugins/org.eclipse.swt."${ws}.${os}.${arch}"_*.jar swt-${SLOT}
	eclipse_unbundle-jar plugins/org.hamcrest.core_*.jar hamcrest-core
	#eclipse_unbundle-jar plugins/org.mortbay.jetty_*.jar jetty
	eclipse_unbundle-jar plugins/org.objectweb.asm_*.jar asm-3
	eclipse_unbundle-jar plugins/org.sat4j.core_*.jar sat4j-core-2
	eclipse_unbundle-jar plugins/org.sat4j.pb_*.jar sat4j-pseudo-2
	popd > /dev/null
}

# Replaces the bundled jars in plugin dir ${1} with links to the jars from
# java-config package ${2}. If ${3} is given, the jars are linked in ${1}/${3}.
eclipse_unbundle-dir() {
	local bundle=${1} package=${2} into=${3}
	local basename=$(basename "${bundle}")
	local barename=${basename%_*}

	if [[ -d "${bundle}" ]] ; then
		einfo "  ${barename} => ${package}"

		pushd "${bundle}" > /dev/null || die
		local classpath=$(manifest_get META-INF/MANIFEST.MF 'Bundle-ClassPath')
		manifest_delete META-INF/MANIFEST.MF 'Name\|SHA1-Digest'
		rm -f ${classpath//,/ } META-INF/ECLIPSEF.{RSA,SF}
		java-pkg_jar-from ${into:+--into "${into}"} "${package}"
		popd > /dev/null
	fi
}

# Converts plugin jar ${1} into a plugin dir, creates symbolic links to the
# jars of java-config package ${2} in that dir, and updates artifacts.xml and
# bundles.info to reflect the fact that the plugin is now a dir.
eclipse_unbundle-jar() {
	local bundle=${1} package=${2} jar=${3}
	local basename=$(basename "${bundle}" .jar)
	local barename=${basename%_*}

	if [[ -f "${bundle}" ]] ; then
		einfo "  ${barename} => ${package}"

		mkdir "${bundle%.jar}"
		pushd "${bundle%.jar}" > /dev/null || die
		"$(java-config --jar)" -xf "../${basename}.jar" plugin.properties META-INF/MANIFEST.MF || die
		java-pkg_jar-from "${package}" ${jar:+"${jar}.jar"}
		local classpath=$(find . -type l -name '*.jar' -print0 | tr '\0' ',')
		classpath=${classpath%,} ; classpath=${classpath//.\/}
		manifest_delete META-INF/MANIFEST.MF 'Name\|SHA1-Digest'
		manifest_replace META-INF/MANIFEST.MF 'Bundle-ClassPath' "${classpath}"
		popd > /dev/null || die
		rm "${bundle}"

		sed_xml_element 'artifact' \
				-e '/id='\'"${barename//./\.}"\''/s|</artifact>|  <repositoryProperties size='\'1\''>\n        <property name='\'artifact.folder\'' value='\'true\''/>\n      </repositoryProperties>\n    \0|' \
				-i artifacts.xml || die
		sed -e 's|'"${bundle//./\.}"'|'"${bundle%.jar}"'/|' \
			-i configuration/org.eclipse.equinox.simpleconfigurator/bundles.info || die
	fi
}

# Removes feature.xml references to plugins matching ${1}.
eclipse_delete-plugins() {
	sed_xml_element 'includes\|plugin' -e '/id="'"${1}"'"/d' \
			-i "${buildDir}"/features/*/feature.xml "${S}"/eclipse-build-feature/feature.xml \
		|| die 'eclipse_delete-plugins failed'
}

# Prints the first value from manifest file ${1} whose key matches regex ${2},
# unfolding as necessary.
manifest_get() {
	sed -n -e '/^\('"${2}"'\): /{h;:A;$bB;n;/^ /!bB;H;bA};d;:B;g;s/^[^:]*: //;s/\n //g;p;q' "${1}" \
		|| die 'manifest_get failed'
}

# Deletes values from manifest file ${1} whose keys match regex ${2}, taking
# into account folding.
manifest_delete() {
	sed -n -e ':A;/^\('"${2}"'\): /{:B;n;/^ /!{bA};bB};p' -i "${1}" \
		|| die 'manifest_delete failed'
}

# Replaces the value for key ${2} in the first section of manifest file ${1}
# with ${3}, or adds the key-value pair to that section if the key was absent.
manifest_replace() {
	LC_ALL='C' awk -v key="${2}" -v val="${3}" '
function fold(s,  o, l, r) {
	o = 2 ; l = length(s) - 1 ; r = substr(s, 1, 1)
	while (l > 69) { r = r substr(s, o, 69) "\n " ; o += 69 ; l -= 69 }
	return r substr(s, o)
}
BEGIN { FS = ": " }
f { print ; next }
i { if ($0 !~ "^ ") { f = 1 ; print } ; next }
$1 == key { print fold(key FS val) ; i = 1 ; next }
/^\r?$/ { print fold(key FS val) ; print ; f = 1 ; next }
{ print }
END { if (!f) { print fold(key FS val) } }
' "${1}" > "${1}-" && mv "${1}"{-,} || die 'manifest_replace failed'
}

# Executes sed over each XML element with a name matching ${1}, rather than
# over each line. The entire element (and its children) may be removed with the
# 'd' command, or they may be edited using all the usual sed foo. Basically,
# the script argument will be executed only for elements matching ${1}, and the
# sed pattern space will consist of the entire element, including any nested
# elements. Note that this is not perfect and requires no more than one XML
# element per line to be reliable.
sed_xml_element() {
	local elem="${1}" ; shift
	sed -e '/<\('"${elem}"'\)\([> \t]\|$\)/{:_1;/>/!{N;b_1};/\/>/b_3' \
			-e ':_2;/<\/\('"${elem}"'\)>/!{N;b_2};b_3};b;:_3' "${@}"
}
