# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-vm-2 prefix versionator

# This URIs need updating when bumping!
JRE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html"

MY_PV="$(get_version_component_range 2-4 ${PV})"

AT_amd64="jre-${MY_PV}_linux-x64_bin.tar.gz"
#AT_x86="jre-${MY_PV}_linux-i586_bin.tar.gz"

DESCRIPTION="Oracle's Java SE Runtime Environment"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
SRC_URI="
	amd64? ( ${AT_amd64} )"
#	x86? ( ${AT_x86} )"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.9"
KEYWORDS="~amd64"
IUSE="alsa commercial cups +fontconfig headless-awt javafx jce nsplugin selinux"

RESTRICT="fetch preserve-libs strip"
QA_PREBUILT="*"

# NOTES:
#
# * cups is dlopened.
#
# * libpng is also dlopened but only by libsplashscreen, which isn't
#   important, so we can exclude that.
#
# * We still need to work out the exact AWT and JavaFX dependencies
#   under MacOS. It doesn't appear to use many, if any, of the
#   dependencies below.
#
RDEPEND="!x64-macos? (
		!headless-awt? (
			x11-libs/libX11
			x11-libs/libXext
			x11-libs/libXi
			x11-libs/libXrender
			x11-libs/libXtst
		)
		javafx? (
			dev-libs/glib:2
			dev-libs/libxml2:2
			dev-libs/libxslt
			media-libs/freetype:2
			x11-libs/cairo
			x11-libs/gtk+:2
			x11-libs/libX11
			x11-libs/libXtst
			x11-libs/libXxf86vm
			x11-libs/pango
			virtual/opengl
		)
	)
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	fontconfig? ( media-libs/fontconfig:1.0 )
	!prefix? ( sys-libs/glibc:* )
	selinux? ( sec-policy/selinux-java )"

DEPEND="app-arch/zip"

S="${WORKDIR}/jre"

pkg_nofetch() {
	local AT_ARCH="AT_${ARCH}"
	local AT="${!AT_ARCH}"

	einfo "Please download '${AT}' from:"
	einfo "'${JRE_URI}'"
	einfo "and move it to '${DISTDIR}'"

	einfo
	einfo "If the above mentioned urls does not point to the correct version anymore,"
	einfo "please download the files from Oracle's java download archive:"
	einfo
	einfo "   http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html#jre-${MY_PV}-oth-JPR"
	einfo

}

src_unpack() {
	default

	# Upstream is changing their versioning scheme every release around 1.8.0.*;
	# to stop having to change it over and over again, just wildcard match and
	# live a happy life instead of trying to get this new jre1.8.0_05 to work.
	mv "${WORKDIR}"/jre* "${S}" || die
}

src_prepare() {
	default

	# Remove the hook that calls Oracle's evil usage tracker. Not just
	# because it's evil but because it breaks the sandbox during builds
	# and we can't find any other feasible way to disable it or make it
	# write somewhere else. See bug #559936 for details.
	#zip -d lib/rt.jar sun/misc/PostVMInitHook.class || die
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"

	# Create files used as storage for system preferences.
	mkdir .systemPrefs || die
	touch .systemPrefs/.system.lock || die
	touch .systemPrefs/.systemRootModFile || die

	if ! use alsa ; then
		rm -vf lib/*/libjsoundalsa.* || die
	fi

	if ! use commercial; then
		rm -vfr lib/jfr* || die
	fi

	if use headless-awt ; then
		rm -vf lib/*/lib*{[jx]awt,splashscreen}* \
		   bin/{javaws,policytool} || die
	fi

	if ! use javafx ; then
		rm -vf lib/*/lib*{decora,fx,glass,prism}* \
		   lib/*/libgstreamer-lite.* lib/{,ext/}*fx* || die
	fi

	if ! use nsplugin ; then
		rm -vf lib/*/libnpjp2.* || die
	else
		local nsplugin=$(echo lib/*/libnpjp2.*)
	fi

	# Even though plugins linked against multiple ffmpeg versions are
	# provided, they generally lag behind what Gentoo has available.
	rm -vf lib/*/libavplugin* || die

	dodoc legal/java.base/COPYRIGHT
	dodir "${dest}"
	cp -pPR	bin lib "${ddest}" || die

	if use nsplugin ; then
		local nsplugin_link=${nsplugin##*/}
		nsplugin_link=${nsplugin_link/./-${PN}-${SLOT}.}
		dosym "${dest}/${nsplugin}" "/usr/$(get_libdir)/nsbrowser/plugins/${nsplugin_link}"
	fi

	# Install desktop file for the Java Control Panel.
	# Using ${PN}-${SLOT} to prevent file collision with jre and or other slots.
	# make_desktop_entry can't be used as ${P} would end up in filename.
	newicon lib/desktop/icons/hicolor/48x48/apps/sun-jcontrol.png \
		sun-jcontrol-${PN}-${SLOT}.png || die
	sed -e "s#Name=.*#Name=Java Control Panel for Oracle JRE ${SLOT}#" \
		-e "s#Exec=.*#Exec=/opt/${P}/bin/jcontrol#" \
		-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}#" \
		-e "s#Application;##" \
		-e "/Encoding/d" \
		lib/desktop/applications/sun_java.desktop > \
		"${T}"/jcontrol-${PN}-${SLOT}.desktop || die
	domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop

	# Prune all fontconfig files so libfontconfig will be used and only install
	# a Gentoo specific one if fontconfig is disabled.
	# http://docs.oracle.com/javase/8/docs/technotes/guides/intl/fontconfig.html
	rm "${ddest}"/lib/fontconfig.* || die
	if ! use fontconfig ; then
		cp "${FILESDIR}"/fontconfig.Gentoo.properties "${T}"/fontconfig.properties || die
		eprefixify "${T}"/fontconfig.properties
		insinto "${dest}"/lib/
		doins "${T}"/fontconfig.properties
	fi

	# This needs to be done before CDS - #215225
	java-vm_set-pax-markings "${ddest}"

	# see bug #207282
	einfo "Creating the Class Data Sharing archives"
	case ${ARCH} in
		arm|ia64)
			${ddest}/bin/java -client -Xshare:dump || die
			;;
		x86)
			${ddest}/bin/java -client -Xshare:dump || die
			# limit heap size for large memory on x86 #467518
			# this is a workaround and shouldn't be needed.
			${ddest}/bin/java -server -Xms64m -Xmx64m -Xshare:dump || die
			;;
		*)
			${ddest}/bin/java -server -Xshare:dump || die
			;;
	esac

	# Remove empty dirs we might have copied.
	find "${D}" -type d -empty -exec rmdir -v {} + || die

	java-vm_install-env "${FILESDIR}"/${PN}.env.sh
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	if ! use headless-awt && ! use javafx; then
		ewarn "You have disabled the javafx flag. Some modern desktop Java applications"
		ewarn "require this and they may fail with a confusing error message."
	fi
}
