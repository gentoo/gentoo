# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit desktop wrapper

MY_PV="213.6777.58"
MY_PN="PhpStorm"

DESCRIPTION="A complete toolset for web, mobile and enterprise development"
HOMEPAGE="https://www.jetbrains.com/phpstorm"
SRC_URI="https://download.jetbrains.com/webide/${MY_PN}-${PV}.tar.gz"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )
	Apache-1.1 Apache-2.0 BSD BSD-2 CC0-1.0 CDDL-1.1 CPL-0.5 CPL-1.0
	EPL-1.0 EPL-2.0 GPL-2 GPL-2-with-classpath-exception GPL-3 ISC JDOM
	LGPL-2.1+ LGPL-3 MIT MPL-1.0 MPL-1.1 OFL public-domain PSF-2 UoI-NCSA ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

BDEPEND="dev-util/patchelf"

RDEPEND="
	app-arch/brotli
	app-arch/zstd
	app-crypt/p11-kit
	dev-libs/libdbusmenu
	dev-libs/fribidi
	dev-libs/glib
	dev-libs/json-c
	dev-libs/nss
	dev-libs/libbsd
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype:2=
	media-libs/harfbuzz
	media-libs/libglvnd
	media-libs/libpng:0=
	media-fonts/dejavu
	media-gfx/graphite2
	net-libs/gnutls
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	sys-libs/zlib
	virtual/jpeg:0=
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"
QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default

	local remove_me=(
		help/ReferenceCardForMac.pdf
		lib/pty4j-native/linux/aarch64
		lib/pty4j-native/linux/arm
		lib/pty4j-native/linux/mips64el
		lib/pty4j-native/linux/ppc64le
		plugins/performanceTesting/bin/*.dll
		plugins/performanceTesting/bin/libyjpagent.dylib
		plugins/performanceTesting/bin/libyjpagent.so
		plugins/remote-dev-server/selfcontained
		plugins/tailwindcss/server/prebuilds/linux-x64/node.napi.musl.node
	)

	use amd64 || remove_me+=( lib/pty4j-native/linux/x86_64 )
	use x86 || remove_me+=( lib/pty4j-native/linux/x86 )

	rm -rv "${remove_me[@]}" || die

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo" bin/idea.properties

	for file in "jbr/lib/"/{libjcef.so,jcef_helper}
	do
		if [[ -f "${file}" ]]; then
			patchelf --set-rpath '$ORIGIN' ${file} || die
		fi
	done
}

src_install() {
	local DIR="/opt/${P}"

	insinto "${DIR}"
	doins -r *
	fperms 755 "${DIR}"/bin/{format.sh,fsnotifier,inspect.sh,ltedit.sh,phpstorm.sh,printenv.py,restart.py}

	fperms 755 "${DIR}"/jbr/bin/{jaotc,java,javac,jcmd,jdb,jfr,jhsdb,jjs,jmap,jps,jrunscript,jstack,jstat,keytool,pack200,rmid,rmiregistry,serialver,unpack200}
	fperms 755 "${DIR}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}

	make_wrapper "${PN}" "${DIR}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "phpstorm" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
  dodir /usr/lib/sysctl.d/
  echo "fs.inotify.max_user_watches = 524288" > "${D}/usr/lib/sysctl.d/30-clion-inotify-watches.conf" || die
}
