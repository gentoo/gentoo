# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop readme.gentoo-r1 wrapper xdg-utils

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

if [[ "${PN}" == *-professional ]]; then
	S="${WORKDIR}/${PN/%-professional/}-${PV}"
fi

LICENSE="Apache-2.0 BSD CDDL MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+bundled-jdk"

if [[ "${PN}" == *-professional ]]; then
	IUSE+=" +bundled-xvfb"
fi

BDEPEND="
	dev-util/patchelf
"

# NOTE
#  The remote-dev-server present in pycharm-professional contains most of the
#  libraries need for the bundled jdk. These are not in the RUNPATH of the jdk.
#  So the dependencies are actually needed.
RDEPEND="
	!bundled-jdk? (
		>=virtual/jre-1.8
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
		sys-libs/zlib
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

if [[ "${PN}" == *-professional ]]; then
RDEPEND+="
	bundled-xvfb? (
		dev-libs/libpcre2
		sys-process/audit
	)
	!bundled-xvfb? (
		x11-base/xorg-server[xvfb]
	)
"
fi

RESTRICT="test"

QA_PREBUILT="opt/${PN}/*"

src_prepare() {
	default

	rm -v  "${S}"/help/ReferenceCardForMac.pdf || die

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

	if use bundled-jdk; then
		patchelf --set-rpath '$ORIGIN/../lib' "jbr/bin/"* || die
		patchelf --set-rpath '$ORIGIN' "jbr/lib/"{libjcef.so,jcef_helper} || die
		patchelf --set-rpath '$ORIGIN:$ORIGIN/server' jbr/lib/lib*.so* || die
	else
		rm -r "jbr" || die
	fi

	if [[ "${PN}" == *-professional ]]; then
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

	if [[ "${PN}" == *-professional ]]; then
		if use bundled-xvfb; then
			fperms 755 "${DIR}"/plugins/remote-dev-server/selfcontained/bin/{Xvfb,xkbcomp}
		fi
		fperms 755 "${DIR}" "${DIR}"/bin/remote-dev-server{,.sh}
	fi

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

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
