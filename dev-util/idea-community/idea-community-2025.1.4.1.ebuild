# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop wrapper

MY_PV=$(ver_cut 1-4)

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/idea"

SRC_URI="
	amd64? ( https://download.jetbrains.com/idea/ideaIC-${MY_PV}.tar.gz -> ${P}-amd64.tar.gz )
	arm64? ( https://download.jetbrains.com/idea/ideaIC-${MY_PV}-aarch64.tar.gz -> ${P}-aarch64.tar.gz )
	"

S="${WORKDIR}/idea-IC-${PV}"
LICENSE="Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CDDL-1.1
	codehaus-classworlds CPL-1.0 EPL-1.0 EPL-2.0
	GPL-2 GPL-2-with-classpath-exception ISC
	JDOM LGPL-2.1 LGPL-2.1+ LGPL-3-with-linking-exception MIT
	MPL-1.0 MPL-1.1 OFL-1.1 ZLIB"

SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="experimental wayland"
REQUIRED_USE="experimental? ( wayland )"

DEPEND=">=virtual/jdk-17:*"

RDEPEND="${DEPEND}
	sys-libs/glibc
	media-libs/harfbuzz
	dev-java/jansi-native
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXrender
	media-libs/freetype
	x11-libs/libXext
	dev-libs/wayland
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libXcomposite
	x11-libs/libXdamage
	x11-libs/libXrandr
	media-libs/alsa-lib
	app-accessibility/at-spi2-core
	x11-libs/cairo
	net-print/cups
	x11-libs/libdrm
	media-libs/mesa
	dev-libs/nspr
	dev-libs/nss
	dev-libs/libdbusmenu
	x11-libs/libxkbcommon
	x11-libs/libXcursor
	x11-libs/pango"

QA_PREBUILT="opt/${PN}/*"

BDEPEND="dev-util/patchelf"
RESTRICT="splitdebug"

src_unpack() {

	default_src_unpack
	if [ ! -d "$S" ]; then
		einfo "Renaming source directory to predictable name..."
		mv $(ls "${WORKDIR}") "idea-IC-${PV}" || die
	fi
}

src_prepare() {

	default_src_prepare

	if use amd64; then
		JRE_DIR=jre64
		rm -vf "${S}"/plugins/cwm-plugin/quiche-native/linux-aarch64/libquiche.so
	else
		JRE_DIR=jre
		rm -vf "${S}"/plugins/cwm-plugin/quiche-native/linux-x86-64/libquiche.so
	fi

	PLUGIN_DIR="${S}/${JRE_DIR}/lib/"

	# rm LLDBFrontEnd after licensing questions with Gentoo License Team
	rm -vf "${S}"/plugins/Kotlin/bin/linux/LLDBFrontend
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

	rm -vf "${S}"/lib/pty4j-native/linux/x86-64/libpty.so

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties

	patchelf --set-rpath '$ORIGIN' "jbr/lib/libjcef.so" || die
	patchelf --set-rpath '$ORIGIN' "jbr/lib/libcef.so" || die
	patchelf --set-rpath '$ORIGIN' "jbr/lib/jcef_helper" || die

	if ! use elibc_musl; then
		rm plugins/platform-ijent-impl/ijent-aarch64-unknown-linux-musl-release
	fi

	eapply_user
}

src_install() {
	local dir="/opt/${PN}"
	local dst="${D}${dir}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{format.sh,idea,idea.sh,inspect.sh,restarter,fsnotifier}

	if [[ -d jbr ]]; then
		fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,jwebserver,keytool,rmiregistry,serialver}

		# Fix #763582
		fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
	fi

	if use amd64; then
		JRE_DIR=jre
		JRE_DIR=jre
	fi

	JRE_BINARIES="jaotc java javapackager jjs jrunscript keytool pack200 rmid rmiregistry unpack200"
	if [[ -d ${JRE_DIR} ]]; then
		for jrebin in $JRE_BINARIES; do
			fperms 755 "${dir}"/"${JRE_DIR}"/bin/"${jrebin}"
		done
	fi

	# bundled script is always lowercase, and doesn't have -ultimate, -professional suffix.
	local bundled_script_name="${PN%-*}.sh"
	make_wrapper "${PN}" "${dir}/bin/$bundled_script_name" || die

	local pngfile="$(find ${dst}/bin -maxdepth 1 -iname '*.png')"
	newicon $pngfile "${PN}.png" || die "we died"

	if use experimental; then
		make_desktop_entry "/opt/idea-community/bin/idea -Dawt.toolkit.name=WLToolkit" \
			"IntelliJ Idea Community Edition" "${PN}" "Development;IDE;"

		ewarn "You have enabled the experimental USE flag."
		ewarn "This is a Wayland support preview. Expect instability."
	else
		make_desktop_entry "/opt/idea-community/bin/idea" \
			"IntelliJ Idea Community Edition" "${PN}" "Development;IDE;"
	fi

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	mkdir -p "${D}/etc/sysctl.d/" || die
	echo "fs.inotify.max_user_watches = 524288" > "${D}/etc/sysctl.d/30-idea-inotify-watches.conf" || die

	# remove bundled harfbuzz
	rm -f "${D}"/lib/libharfbuzz.so || die "Unable to remove bundled harfbuzz"
}
