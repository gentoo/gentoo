# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

CHROMIUM_LANGS="am ar bg bn ca cs da de el en_GB es es_LA et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt_BR pt_PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh_CN zh_TW"

inherit readme.gentoo chromium eutils multilib pax-utils unpacker

DESCRIPTION="The web browser from Google"
HOMEPAGE="https://www.google.com/chrome"

if [[ ${PN} == google-chrome ]]; then
	MY_PN=${PN}-stable
else
	MY_PN=${PN}
fi

MY_P="${MY_PN}_${PV/_p/-}"

SRC_URI="
	amd64? (
		https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb
	)
	x86? (
		https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_i386.deb
	)
"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="+plugins"
RESTRICT="bindist mirror strip"

RDEPEND="
	app-arch/bzip2
	app-misc/ca-certificates
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype:2
	net-print/cups
	sys-apps/dbus
	sys-libs/libcap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	>=x11-libs/libX11-1.5.0
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango
	x11-misc/xdg-utils
"

QA_PREBUILT="*"
S=${WORKDIR}
CHROME_HOME="opt/google/chrome${PN#google-chrome}"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Some web pages may require additional fonts to display properly.
Try installing some of the following packages if some characters
are not displayed properly:
- media-fonts/arphicfonts
- media-fonts/bitstream-cyberbit
- media-fonts/droid
- media-fonts/ipamonafont
- media-fonts/ja-ipafonts
- media-fonts/takao-fonts
- media-fonts/wqy-microhei
- media-fonts/wqy-zenhei

Depending on your desktop environment, you may need
to install additional packages to get icons on the Downloads page.

For KDE, the required package is kde-apps/oxygen-icons.

For other desktop environments, try one of the following:
- x11-themes/gnome-icon-theme
- x11-themes/tango-icon-theme

Please notice the bundled flash player (PepperFlash).
You can (de)activate all flash plugins via chrome://plugins
"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for google-chrome fetch failures."
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_install() {
	rm -r usr/share/menu || die
	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die

	pushd "${CHROME_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	if use plugins ; then
		local plugins="--extra-plugin-dir=/usr/$(get_libdir)/nsbrowser/plugins"
		sed -e "/^exec/ i set -- \"${plugins}\" \"\$@\"" \
			-i "${CHROME_HOME}/${PN}" || die
	fi

	local size
	for size in 16 22 24 32 48 64 128 256 ; do
		newicon -s ${size} "${CHROME_HOME}/product_logo_${size}.png" ${PN}.png
	done

	insinto /
	doins -r opt usr

	find "${ED}" -type d -empty -delete || die
	chmod 755 "${ED}${CHROME_HOME}"/{chrome,${PN},nacl_helper{,_bootstrap},xdg-{mime,settings}} || die
	chmod 4755 "${ED}${CHROME_HOME}/chrome-sandbox" || die
	pax-mark m "${ED}${CHROME_HOME}/chrome"

	readme.gentoo_create_doc
}

any_cpu_missing_flag() {
	local value=$1
	grep '^flags' /proc/cpuinfo | grep -qv "$value"
}

pkg_preinst() {
	chromium_pkg_preinst
	if any_cpu_missing_flag sse2; then
		ewarn "The bundled PepperFlash plugin requires a CPU that supports the"
		ewarn "SSE2 instruction set, and at least one of your CPUs does not"
		ewarn "support this feature. Disabling PepperFlash."
		sed -e "/^exec/ i set -- --disable-bundled-ppapi-flash \"\$@\"" \
			-i "${ED}${CHROME_HOME}/google-chrome" || die
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
	readme.gentoo_print_elog
}
