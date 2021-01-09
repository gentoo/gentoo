# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils desktop

SLOT="0"
PV_STRING="$(ver_cut 2-6)"
MY_PV="$(ver_cut 1-3)"
MY_PN="idea"
# Using the most recent Jetbrains Runtime binaries available at the time of writing
# ( jre 11.0.8 build 1098.1  )
JRE11_BASE="11_0_8"
JRE11_VER="1098.1"

# distinguish settings for official stable releases and EAP-version releases
if [[ "$(ver_cut 7)"x = "prex" ]]
then
	# upstream EAP
	KEYWORDS="~arm64"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${PV_STRING}.tar.gz"
else
	# upstream stable
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="https://download.jetbrains.com/idea/${MY_PN}IC-${MY_PV}-no-jbr.tar.gz -> ${MY_PN}IC-${PV_STRING}.tar.gz
		amd64? ( https://bintray.com/jetbrains/intellij-jbr/download_file?file_path=jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz -> jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz )"
fi

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1
	codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0
	GPL-2 GPL-2-with-classpath-exception ISC
	JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT
	MPL-1.0 MPL-1.1 OFL ZLIB"

DEPEND="!dev-util/${PN}:14
	!dev-util/${PN}:15
	|| (
		dev-java/openjdk:11
		dev-java/openjdk-bin:11
	)"
RDEPEND="${DEPEND}
	dev-java/jansi-native
	dev-libs/libdbusmenu
	=dev-util/lldb-10*
	|| (
		dev-java/openjdk:11
		dev-java/openjdk-bin:11
	)"
BDEPEND="dev-util/patchelf"
RESTRICT="splitdebug"
S="${WORKDIR}/${MY_PN}-IC-$(ver_cut 4-6)"

QA_PREBUILT="opt/${PN}-${MY_PV}/*"

PATCHES=(
	"${FILESDIR}/${PN}-jdk.patch"
)

src_unpack() {
	default_src_unpack
	mkdir jre64 && cd jre64 && unpack jbr-${JRE11_BASE}-linux-x64-b${JRE11_VER}.tar.gz
}

src_prepare() {

	default_src_prepare

	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi

	PLUGIN_DIR="${S}/${JRE_DIR}/lib/"

	rm -vf ${PLUGIN_DIR}/libavplugin*
	rm -vf "${S}"/plugins/maven/lib/maven3/lib/jansi-native/*/libjansi*
	rm -vrf "${S}"/lib/pty4j-native/linux/ppc64le
	rm -vf "${S}"/bin/libdbm64*
	rm -vf "${S}"/lib/pty4j-native/linux/mips64el/libpty.so

	if [[ -d "${S}"/"${JRE_DIR}" ]]; then
		for file in "${PLUGIN_DIR}"/{libfxplugins.so,libjfxmedia.so}
		do
			if [[ -f "$file" ]]; then
			  patchelf --set-rpath '$ORIGIN' $file || die
			fi
		done
	fi

	patchelf --replace-needed liblldb.so liblldb.so.10 "${S}"/plugins/Kotlin/bin/linux/LLDBFrontend || die "Unable to patch LLDBFrontend for lldb"
	if use arm64; then
		patchelf --replace-needed libc.so libc.so.6 "${S}"/lib/pty4j-native/linux/aarch64/libpty.so || die "Unable to patch libpty for libc"
	else
		rm -vf "${S}"/lib/pty4j-native/linux/aarch64/libpty.so
	fi

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	eapply_user
}

src_install() {
	local dir="/opt/${PN}-${MY_PV}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,idea.sh,inspect.sh,printenv.py,restart.py,fsnotifier{,64}}
	if use amd64; then
		JRE_DIR=jre64
	else
		JRE_DIR=jre
	fi

	JRE_BINARIES="jaotc java javapackager jjs jrunscript keytool pack200 rmid rmiregistry unpack200"
	if [[ -d ${JRE_DIR} ]]; then
		for jrebin in $JRE_BINARIES; do
			fperms 755 "${dir}"/"${JRE_DIR}"/bin/"${jrebin}"
		done
	fi

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.png" "${PN}.png"
	make_desktop_entry "${PN}" "IntelliJ Idea Community" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die
}
