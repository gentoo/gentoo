# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop gnome2-utils java-vm-2 prefix versionator

KEYWORDS="-* amd64 x86"

if [[ "$(get_version_component_range 4)" == 0 ]] ; then
	S_PV="$(get_version_component_range 1-3)"
else
	MY_PV_EXT="u$(get_version_component_range 4)"
	S_PV="$(get_version_component_range 1-4)"
fi

MY_PV="$(get_version_component_range 2)${MY_PV_EXT}"

declare -A ARCH_FILES
ARCH_FILES[amd64]="jre-${MY_PV}-linux-x64.tar.gz"
ARCH_FILES[x86]="jre-${MY_PV}-linux-i586.tar.gz"

for keyword in ${KEYWORDS//-\*} ; do
	SRC_URI+=" ${keyword#\~}? ( ${ARCH_FILES[${keyword#\~}]} )"
done

DESCRIPTION="Oracle's Java SE Runtime Environment"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.8"
IUSE="alsa commercial cups +fontconfig headless-awt javafx jce nsplugin selinux"
RESTRICT="bindist fetch preserve-libs strip"
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

S="${WORKDIR}/jre$(replace_version_separator 3 _  ${S_PV})"

pkg_nofetch() {
	einfo "Please download ${ARCH_FILES[${ARCH}]} and move it to"
	einfo "your distfiles directory:"
	einfo
	einfo "  http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html"
	einfo
	einfo "If the above mentioned URL does not point to the correct version anymore,"
	einfo "please download the file from Oracle's Java download archive:"
	einfo
	einfo "  http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase8-2177648.html"
	einfo
}

src_prepare() {
	default

	# Remove the hook that calls Oracle's evil usage tracker. Not just
	# because it's evil but because it breaks the sandbox during builds
	# and we can't find any other feasible way to disable it or make it
	# write somewhere else. See bug #559936 for details.
	zip -d lib/rt.jar sun/misc/PostVMInitHook.class || die
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

	if ! use commercial ; then
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
		local nsplugin_link=${nsplugin##*/}
		nsplugin_link=${nsplugin_link/./-${PN}-${SLOT}.}
		dosym "${dest}/${nsplugin}" "/usr/$(get_libdir)/nsbrowser/plugins/${nsplugin_link}"
	fi

	# Even though plugins linked against multiple ffmpeg versions are
	# provided, they generally lag behind what Gentoo has available.
	rm -vf lib/*/libavplugin* || die

	# Prune all fontconfig files so that libfontconfig will be used.
	rm -v lib/fontconfig.* || die

	# Install desktop file for the Java Control Panel. Using
	# ${PN}-${SLOT} to prevent file collision with JDK and other slots.
	if [[ -d lib/desktop/icons ]] ; then
		local icon
		pushd lib/desktop/icons >/dev/null || die
		for icon in */*/apps/sun-jcontrol.png ; do
			insinto /usr/share/icons/"${icon%/*}"
			newins "${icon}" sun-jcontrol-${PN}-${SLOT}.png
		done
		popd >/dev/null || die
		make_desktop_entry \
			"${dest}"/bin/jcontrol \
			"Java Control Panel for Oracle JRE ${SLOT}" \
			sun-jcontrol-${PN}-${SLOT} \
			"Settings;Java;"
	fi

	dodoc COPYRIGHT
	dodir "${dest}"
	cp -pPR	bin lib man "${ddest}" || die

	ln -s policy/$(usex jce unlimited limited)/{US_export,local}_policy.jar \
		"${ddest}"/lib/security/ || die

	# Only install Gentoo-specific fontconfig if flag is disabled.
	# https://docs.oracle.com/javase/8/docs/technotes/guides/intl/fontconfig.html
	if ! use fontconfig ; then
		insinto "${dest}"/lib/
		doins "$(prefixify_ro "${FILESDIR}"/fontconfig.properties)"
	fi

	# Needs to be done before CDS, bug #215225.
	java-vm_set-pax-markings "${ddest}"

	# See bug #207282.
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

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	java-vm-2_pkg_postinst

	if ! use headless-awt && ! use javafx ; then
		ewarn "You have disabled the javafx flag. Some modern desktop Java applications"
		ewarn "require this and they may fail with a confusing error message."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
	java-vm-2_pkg_postrm
}
