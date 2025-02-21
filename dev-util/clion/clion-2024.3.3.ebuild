# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper optfeature

DESCRIPTION="A complete toolset for C and C++ development"
HOMEPAGE="https://www.jetbrains.com/clion/"
SRC_URI="https://download.jetbrains.com/cpp/CLion-${PV}.tar.gz"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )
	Apache-1.1 Apache-2.0 BSD BSD-2 CC0-1.0 CDDL-1.1 CPL-0.5 CPL-1.0
	EPL-1.0 EPL-2.0 GPL-2 GPL-2-with-classpath-exception GPL-3 ISC JDOM
	LGPL-2.1+ LGPL-3 MIT MPL-1.0 MPL-1.1 OFL-1.1 public-domain PSF-2
	UoI-NCSA ZLIB"
SLOT="0/2024"
KEYWORDS="~amd64"
RESTRICT="bindist mirror"

BDEPEND="dev-util/patchelf"

RDEPEND="
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-util/lttng-ust:0/2.12
	dev-libs/nspr
	dev-libs/nss
	dev-libs/wayland
	dev-build/cmake
	app-alternatives/ninja
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/zlib
	x11-libs/cairo
	x11-libs/libdrm
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
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango"

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default

	local remove_me=(
		Install-Linux-tar.txt
		help/ReferenceCardForMac.pdf
		bin/cmake
		bin/gdb/linux
		bin/lldb/linux
		bin/ninja
		lib/async-profiler/aarch64
		plugins/clion-radler/DotFiles/linux-arm64
		plugins/clion-radler/dotTrace.dotMemory/DotFiles/linux-arm64
		plugins/remote-dev-server/selfcontained
		plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_aarch64.so
	)

	rm -rv "${remove_me[@]}" || die

	# removing debug symbols and relocating debug files as per #876295
	# we're escaping all the files that contain $() in their name
	# as they should not be executed
	find . -type f ! -name '*$(*)*' -exec sh -c '
		if file "{}" | grep -qE "ELF (32|64)-bit"; then
			objcopy --remove-section .note.gnu.build-id "{}"
			debugedit -b "${EPREFIX}/opt/${PN}" -d "/usr/lib/debug" -i "{}"
		fi
	' \;

	patchelf --set-rpath '$ORIGIN' "jbr/lib/libjcef.so" || die
	patchelf --set-rpath '$ORIGIN' "jbr/lib/jcef_helper" || die
	patchelf --set-rpath '$ORIGIN/../lib' "bin/clang/linux/x64/lib/libclazyPlugin.so" || die
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{clion.sh,format.sh,fsnotifier,inspect.sh,jetbrains_client.sh,ltedit.sh,remote-dev-server.sh,restarter,clang/linux/x64/bin/{clangd,clang-tidy,clazy-standalone,llvm-symbolizer}}

	if [[ -d jbr ]]; then
		fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}
		# Fix #763582
		fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
	fi

	fperms 755 "${dir}"/plugins/clion-radler/DotFiles/linux-x64/Rider.Backend

	dosym -r "${EPREFIX}/usr/bin/ninja" "${dir}"/bin/ninja/linux/x64/ninja

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "CLion" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	insinto /usr/lib/sysctl.d
	newins - 30-"${PN}"-inotify-watches.conf <<<"fs.inotify.max_user_watches = 524288"
}

pkg_postinst() {
	optfeature "Debugging support" dev-debug/gdb
}
