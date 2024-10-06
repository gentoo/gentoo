# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper xdg

MY_PN=${PN/-professional/}
DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="https://www.jetbrains.com/pycharm/"
SRC_URI="
	amd64? ( https://download.jetbrains.com/python/${P}.tar.gz )
	arm64? ( https://download.jetbrains.com/python/${P}-aarch64.tar.gz )
"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="PyCharm"
#https://www.jetbrains.com/legal/third-party-software/?product=pcp
#license/javahelp_license.txt: CDDL-1.1
#license/javolution_license.txt: BSD-2
#license/saxon-conditions.html: MPL-1.0
#license/yourkit-license-redist.txt: BSD
#license/third-party-libraries.json:
## cat third-party-libraries.json | jq '.[].license' | sort | uniq
# "commercial, available on request" http://www.yworks.com/products/yfiles-for-java-2.x/sla
# "Custom" https://checkmarx.com/legal/jetbrains-checkmarx-end-user-terms-and-conditions/
# color.js is MIT
# codehaus is MIT
# roman.py is ZPL not "Python 2.1.1 license"
# Eclipse Distribution License 1.0 is BSD
LICENSE+=" 0BSD Apache-2.0 BSD BSD-2 CC0-1.0 CC-BY-2.5 CC-BY-3.0 CC-BY-4.0 CDDL-1.1 CPL-1.0 EPL-1.0 GPL-2"
LICENSE+=" GPL-2-with-classpath-exception ISC JSON LGPL-2.1 LGPL-3 LGPL-3+ libpng MIT MPL-1.1 MPL-2.0"
LICENSE+=" OFL-1.1 public-domain PYTHON unicode Unlicense W3C ZLIB ZPL"
SLOT="0"
KEYWORDS="amd64"
IUSE="+bundled-jdk"

RDEPEND="
	dev-libs/glib:2
	dev-python/pip
	media-fonts/dejavu
	bundled-jdk? (
		app-accessibility/at-spi2-core:2
		dev-libs/expat
		dev-libs/nspr
		dev-libs/nss
		media-libs/alsa-lib
		media-libs/freetype:2=
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
	!bundled-jdk? (
		>=virtual/jre-17
	)
"
BDEPEND="dev-util/patchelf"

RESTRICT="mirror"

DESTDIR="/opt/${PN}"
QA_PREBUILT="${DESTDIR#/}/.*"

src_prepare() {
	default
	local remove_me=(
		help/ReferenceCardForMac.pdf
		plugins/remote-dev-server/selfcontained
		plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_x86.so
		plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_amd64.so
		plugins/python-ce/helpers/pydev/pydevd_attach_to_process/attach_linux_aarch64.so
		plugins/tailwindcss  # Relies on masked package sys-libs/musl
	)

	if use amd64; then
		remove_me+=(
			lib/async-profiler/aarch64
		)
	fi

	if use arm64; then
		remove_me+=(
			lib/async-profiler/amd64
		)
	fi

	rm -rv "${remove_me[@]}" || die

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo" \
		bin/idea.properties || die

	if ! use bundled-jdk; then
		rm -rf jbr || die
	fi

	local file
	for file in jbr/lib/{libjcef.so,jcef_helper}; do
		if [[ -f ${file} ]]; then
			patchelf --set-rpath '$ORIGIN' ${file} || die
		fi
	done
}

src_install() {
	insinto ${DESTDIR}
	doins -r *

	fperms 755 ${DESTDIR}/bin/{format.sh,fsnotifier,inspect.sh,jetbrains_client.sh,ltedit.sh,pycharm.sh,remote-dev-server.sh,repair,restarter}

	if use bundled-jdk; then
		fperms 755 "${DESTDIR}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}
		fperms 755 "${DESTDIR}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
	fi

	make_wrapper ${PN} ${DESTDIR}/bin/pycharm.sh
	newicon bin/${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	insinto /usr/lib/sysctl.d
	newins - 30-idea-inotify-watches.conf <<<"fs.inotify.max_user_watches = 524288"
}
