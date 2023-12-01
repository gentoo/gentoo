# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop readme.gentoo-r1 wrapper xdg-utils

MY_PN=${PN/-professional/}
DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="https://www.jetbrains.com/pycharm/"
SRC_URI="https://download.jetbrains.com/python/${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="PyCharm_Academic PyCharm_Classroom PyCharm PyCharm_OpenSource PyCharm_Preview"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+bundled-jdk"

BDEPEND="dev-util/patchelf"

RDEPEND="!bundled-jdk? ( >=virtual/jre-1.8 )
	app-accessibility/at-spi2-core:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	dev-python/pip
	media-fonts/dejavu
	media-libs/alsa-lib
	media-libs/freetype:2=
	media-libs/mesa
	net-print/cups
	sys-apps/dbus
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libxkbcommon
	x11-libs/libXxf86vm
"

RESTRICT="mirror"

QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default
	local remove_me=(
		help/ReferenceCardForMac.pdf
		plugins/remote-dev-server/selfcontained
		plugins/python/helpers/pydev/pydevd_attach_to_process/attach_linux_x86.so
		plugins/python/helpers/pydev/pydevd_attach_to_process/attach_linux_amd64.so
		plugins/python/helpers/pydev/pydevd_attach_to_process/attach_linux_aarch64.so
		plugins/cwm-plugin/quiche-native/linux-aarch64
		plugins/tailwindcss  # Relies on masked package sys-libs/musl
)

	rm -rv "${remove_me[@]}" || die

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo" \
		bin/idea.properties || die

	local file
	for file in jbr/lib/{libjcef.so,jcef_helper}; do
		if [[ -f ${file} ]]; then
			patchelf --set-rpath '$ORIGIN' ${file} || die
		fi
	done
}

src_install() {
	local dir="/opt/${PN}"
	local jre_dir="jbr"

	insinto ${dir}
	doins -r *

	if ! use bundled-jdk; then
		rm -r "${jre_dir}" || die
	fi

	fperms 755 ${dir}/bin/{format.sh,fsnotifier,inspect.sh,ltedit.sh,pycharm.sh,restart.py}

	fperms 755 "${dir}"/"${jre_dir}"/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}
	fperms 755 "${dir}"/"${jre_dir}"/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}

	make_wrapper ${PN} ${dir}/bin/pycharm.sh
	newicon bin/${MY_PN}.png ${PN}.png
	make_desktop_entry ${PN} ${PN} ${PN}

	readme.gentoo_create_doc

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	insinto /usr/lib/sysctl.d
	newins - 30-idea-inotify-watches.conf <<<"fs.inotify.max_user_watches = 524288"
}

pkg_postinst() {
	readme.gentoo_print_elog
	xdg_icon_cache_update
}
