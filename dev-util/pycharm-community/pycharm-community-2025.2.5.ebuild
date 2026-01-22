# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop readme.gentoo-r1 toolchain-funcs wrapper xdg

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"

# NOTE upstream release info
# https://data.services.jetbrains.com/products?code=PCP,PCC&release.type=release
# https://data.services.jetbrains.com/products?code=PCP,PCC&release.type=release&fields=name,releases

HOMEPAGE="https://www.jetbrains.com/pycharm/"
SRC_URI="
	amd64? (
		https://download.jetbrains.com/python/${P}.tar.gz
	)
	arm64? (
		https://download.jetbrains.com/python/${P}-aarch64.tar.gz
	)
	x86? (
		https://download.jetbrains.com/python/${P}.tar.gz
	)
"

if [[ ${PN} == *-professional ]]; then
	S="${WORKDIR}/${PN/%-professional/}-${PV}"
	LICENSE="|| ( JetBrains-business JetBrains-classroom JetBrains-educational JetBrains-individual )
	Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CC-BY-3.0 CC-BY-4.0 CPL-1.0 CDDL CDDL-1.1 EPL-1.0 EPL-2.0
	GPL-2 GPL-2-with-classpath-exception ISC JDOM LGPL-2.1 LGPL-3 MIT MPL-1.1 MPL-2.0 OFL-1.1
	PYTHON Unicode-DFS-2016 Unlicense UPL-1.0 ZLIB"
else
	LICENSE="|| ( JetBrains-business JetBrains-classroom JetBrains-educational JetBrains-individual )
	Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CC-BY-3.0 CPL-1.0 CDDL-1.1 EPL-1.0 GPL-2
	GPL-2-with-classpath-exception ISC JDOM JSON LGPL-2+ LGPL-2.1 LGPL-3 MIT MPL-1.1 MPL-2.0
	OFL-1.1 UPL-1.0 ZLIB"
fi

SLOT="0/2025"
KEYWORDS="-* amd64 ~arm64 ~x86"
IUSE="+bundled-jdk"

if [[ ${PN} == *-professional ]]; then
	IUSE+=" +bundled-xvfb"
fi

BDEPEND="dev-util/debugedit
	dev-util/patchelf
"

# NOTE
#  The remote-dev-server present in pycharm-professional contains most of the
#  libraries need for the bundled jdk. These are not in the RUNPATH of the jdk.
#  So the dependencies are actually needed.
RDEPEND="
	!bundled-jdk? (
		>=virtual/jre-17:*
	)
	bundled-jdk? (
		app-accessibility/at-spi2-core:2
		dev-libs/expat
		dev-libs/glib:2
		dev-libs/nspr
		dev-libs/nss
		dev-libs/wayland
		media-libs/alsa-lib
		media-libs/freetype
		media-libs/mesa
		net-print/cups
		sys-apps/dbus
		virtual/zlib:=
		x11-libs/cairo
		x11-libs/libX11
		x11-libs/libXcomposite
		x11-libs/libXcursor
		x11-libs/libXdamage
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXi
		x11-libs/libXrandr
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libXxf86vm
		x11-libs/libdrm
		x11-libs/libxcb
		x11-libs/libxkbcommon
		x11-libs/pango
	)
"

if [[ ${PN} == *-professional ]]; then
RDEPEND+="
	bundled-xvfb? (
		dev-libs/libpcre2
		sys-libs/pam
		sys-process/audit
	)
	!bundled-xvfb? (
		x11-base/xorg-server[xvfb]
	)
"
fi

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	tc-export OBJCOPY
	default

	rm -v "${S}"/help/ReferenceCardForMac.pdf || die
	rm -v "${S}"/plugins/python-ce/helpers/pydev/_pydevd_{bundle,frame_eval}/*{darwin,win32}* || die

	if ! use amd64; then
		rm -v  "${S}"/plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_amd64.so || die
		if [[ -d "${S}"/lib/async-profiler/ ]]; then
			rm -v  "${S}"/lib/async-profiler/amd64/libasyncProfiler.so || die
		fi
	fi
	if ! use arm64; then
		rm -v  "${S}"/plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_aarch64.so || die
		if [[ -d "${S}"/lib/async-profiler/ ]]; then
			rm -v  "${S}"/lib/async-profiler/aarch64/libasyncProfiler.so || die
		fi
	fi
	if ! use x86; then
		rm -v  "${S}"/plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_x86.so || die
	fi

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo" bin/idea.properties

	# excepting files from different architectures that should be kept for remote plugins
	if ! use arm64; then
		local skip_remote_files=(
			"plugins/platform-ijent-impl/ijent-aarch64-unknown-linux-musl-release"
			"plugins/clion-radler/DotFiles/linux-musl-arm64/jb_zip_unarchiver"
			"plugins/clion-radler/DotFiles/linux-arm/jb_zip_unarchiver"
			"plugins/clion-radler/DotFiles/linux-musl-arm/jb_zip_unarchiver"
			"plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-linux-arm64"
		)
	elif ! use amd64 ; then
		local skip_remote_files=(
			"plugins/platform-ijent-impl/ijent-x86_64-unknown-linux-musl-release"
			"plugins/clion-radler/DotFiles/linux-musl-x64/jb_zip_unarchiver"
			"plugins/clion-radler/DotFiles/linux-x86/jb_zip_unarchiver"
			"plugins/clion-radler/DotFiles/linux-musl-x86/jb_zip_unarchiver"
			"plugins/gateway-plugin/lib/remote-dev-workers/remote-dev-worker-linux-x64"
		)
	fi
	# removing debug symbols and relocating debug files as per #876295
	# we're escaping all the files that contain $() in their name
	# as they should not be executed
	find . -type f ! -name '*$(*)*' -print0 | while IFS= read -r -d '' file; do
		for skip in "${skip_remote_files[@]}"; do
			[[ ${file} == "./${skip}" ]] && continue 2
		done
		if file "${file}" | grep -qE "ELF (32|64)-bit"; then
			${OBJCOPY} --remove-section .note.gnu.build-id "${file}" || die
			debugedit -b "${EPREFIX}/opt/${PN}" -d "/usr/lib/debug" -i "${file}" || die
		fi
	done

	if use bundled-jdk; then
		patchelf --set-rpath '$ORIGIN/../lib' "jbr/bin/"* || die
		patchelf --set-rpath '$ORIGIN' "jbr/lib/"{libjcef.so,jcef_helper} || die
		patchelf --set-rpath '$ORIGIN:$ORIGIN/server' jbr/lib/lib*.so* || die
	else
		rm -r "jbr" || die
	fi

	if [[ ${PN} == *-professional ]]; then
		if use bundled-xvfb; then
			patchelf --set-rpath '$ORIGIN/../lib' "${S}"/plugins/remote-dev-server/selfcontained/bin/{Xvfb,xkbcomp} || die
			patchelf --set-rpath '$ORIGIN' "${S}"/plugins/remote-dev-server/selfcontained/lib/lib*.so* || die
		else
			rm -vr "${S}"/plugins/remote-dev-server/selfcontained || die
			sed '/export REMOTE_DEV_SERVER_IS_NATIVE_LAUNCHER/a export REMOTE_DEV_SERVER_USE_SELF_CONTAINED_LIBS=1' \
			  -i bin/remote-dev-server.sh || die
		fi
	fi
}

src_configure() {
	:;
}

src_compile() {
	:;
}

src_install() {
	local DIR="/opt/${PN}"
	local JRE_DIR="jbr"

	insinto "${DIR}"
	doins -r ./*

	fperms 755 "${DIR}"/bin/{format.sh,fsnotifier,inspect.sh,jetbrains_client.sh,ltedit.sh,pycharm,pycharm.sh,restarter}

	if use bundled-jdk; then
		fperms 755 "${DIR}/${JRE_DIR}"/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,jwebserver,keytool,rmiregistry,serialver}
		fperms 755 "${DIR}"/"${JRE_DIR}"/lib/{cef_server,chrome-sandbox,jcef_helper,jexec,jspawnhelper}
	fi

	if [[ ${PN} == *-professional ]]; then
		if use bundled-xvfb; then
			fperms 755 "${DIR}"/plugins/remote-dev-server/selfcontained/bin/{Xvfb,xkbcomp}
		fi
		fperms 755 "${DIR}" "${DIR}"/bin/remote-dev-server{,.sh}
	fi

	# we have to strip files that are not related to the current architecture
	dostrip -x "${skip_remote_files[@]/#//opt/${PN}/}"

	make_wrapper "${PN}" "${DIR}/bin/pycharm"
	newicon "bin/${PN/%-*/}.png" "${PN}.png"
	make_desktop_entry "${PN}" "${PN}" "${PN}"

	readme.gentoo_create_doc

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d
	cat > "${ED}/usr/lib/sysctl.d/30-${PN}-inotify-watches.conf" <<-EOF || die
		fs.inotify.max_user_watches = 524288
	EOF
}
