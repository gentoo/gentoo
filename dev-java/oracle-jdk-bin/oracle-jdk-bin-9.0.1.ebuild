# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils java-vm-2 prefix versionator

JDK_URI="http://www.oracle.com/technetwork/java/javase/downloads/jdk9-downloads-3848520.html"

MY_PV="${PV}"

# This is a list of archs supported by this update.
# Currently arm comes and goes.
AT_AVAILABLE=( amd64 sparc64-solaris x64-macos )
DEMOS_AVAILABLE=( )

AT_amd64="jdk-${MY_PV}_linux-x64_bin.tar.gz"
AT_arm="jdk-${MY_PV}_linux-arm32-vfp-hflt_bin.tar.gz"
AT_arm64="jdk-${MY_PV}_linux-arm64-vfp-hflt_bin.tar.gz"
AT_x86="jdk-${MY_PV}_linux-x86_bin.tar.gz"
AT_x64_solaris="jdk-${MY_PV}_solaris-x64_bin.tar.gz"
AT_sparc64_solaris="jdk-${MY_PV}_solaris-sparcv9_bin.tar.gz"
AT_x64_macos="jdk-${MY_PV}_osx-x64_bin.dmg"
DEMOS_amd64="jdk-${MY_PV}-linux-x64_bin-demos.tar.gz"
DEMOS_arm="jdk-${MY_PV}-linux-arm32-vfp-hflt_bin-demos.tar.gz"
DEMOS_arm64="jdk-${MY_PV}-linux-arm64-vfp-hflt_bin-demos.tar.gz"
DEMOS_x86="jdk-${MY_PV}-linux-i586_bin-demos.tar.gz"
DEMOS_x64_solaris="jdk-${MY_PV}-solaris-x64_bin-demos.tar.gz"
DEMOS_sparc64_solaris="jdk-${MY_PV}-solaris-sparcv9_bin-demos.tar.gz"
DEMOS_x64_macos="jdk-${MY_PV}-macosx-x86_64_bin-demos.zip"

DESCRIPTION="Oracle's Java SE Development Kit"
HOMEPAGE="http://jdk.java.net/$(get_version_component_range 1)/"
for file in "${AT_AVAILABLE[@]}"; do
	SRC_URI+=" ${file}? ( $(eval "echo \${$(echo AT_${file/-/_})}")"
	if has ${file} "${DEMOS_AVAILABLE[@]}"; then
		SRC_URI+=" examples? ( $(eval "echo \${$(echo DEMOS_${file/-/_})}") )"
	fi
	SRC_URI+=" )"
done
unset file

LICENSE="Oracle-BCLA-JavaSE"
SLOT="$(get_version_component_range 1)"
KEYWORDS="~arm ~arm64 ~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc64-solaris ~x64-solaris"
IUSE="alsa commercial cups doc examples +fontconfig headless-awt javafx nsplugin selinux source"
REQUIRED_USE="javafx? ( alsa fontconfig )"

RESTRICT="preserve-libs fetch strip"
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
	doc? ( dev-java/java-sdk-docs:${SLOT} )
	fontconfig? ( media-libs/fontconfig:1.0 )
	!prefix? ( sys-libs/glibc:* )
	selinux? ( sec-policy/selinux-java )"

DEPEND="app-arch/zip"

S="${WORKDIR}/jdk"

check_tarballs_available() {
	local uri=$1; shift
	local dl= unavailable=
	for dl in "${@}" ; do
		[[ ! -f "${DISTDIR}/${dl}" ]] && unavailable+=" ${dl}"
	done

	if [[ -n "${unavailable}" ]] ; then
		if [[ -z ${_check_tarballs_available_once} ]] ; then
			einfo
			einfo "Oracle requires you to download the needed files manually after"
			einfo "accepting their license through a javascript capable web browser."
			einfo
			_check_tarballs_available_once=1
		fi
		einfo "Download the following files:"
		for dl in ${unavailable}; do
			einfo "  ${dl}"
		done
		einfo "at '${uri}'"
		einfo "and move them to '${DISTDIR}'"
		einfo
		einfo "If the above mentioned urls do not point to the correct version anymore,"
		einfo "please download the files from Oracle's java download archive:"
		einfo
		einfo "   http://www.oracle.com/technetwork/java/javase/downloads/java-archive-javase9-3934878.html"
		einfo
	fi
}

pkg_nofetch() {
	local distfiles=( $(eval "echo \${$(echo AT_${ARCH/-/_})}") )
	if use examples && has ${ARCH} "${DEMOS_AVAILABLE[@]}"; then
		distfiles+=( $(eval "echo \${$(echo DEMOS_${ARCH/-/_})}") )
	fi
	check_tarballs_available "${JDK_URI}" "${distfiles[@]}"
}

src_unpack() {
	if use x64-macos ; then
		pushd "${T}" > /dev/null || die
		mkdir dmgmount || die
		hdiutil attach "${DISTDIR}"/jdk-${MY_PV}-macosx-x64.dmg \
			-mountpoint "${T}"/dmgmount || die
		local update=$(get_version_component_range 4)
		[[ ${#update} == 1 ]] && update="0${update}"
		xar -xf dmgmount/JDK\ $(get_version_component_range 2)\ Update\ ${update}.pkg || die
		hdiutil detach "${T}"/dmgmount || die
		zcat jdk1${MY_PV%u*}0${update}.pkg/Payload | cpio -idv || die
		mv Contents/Home "${WORKDIR}"/jdk${MY_PV} || die
		popd > /dev/null || die
	else
		default
	fi

	# Upstream is changing their versioning scheme every release around 1.8.0.*;
	# to stop having to change it over and over again, just wildcard match and
	# live a happy life instead of trying to get this new jdk1.8.0_05 to work.
	mv "${WORKDIR}"/jdk* "${S}" || die
}

src_prepare() {
	default

	if [[ -n ${JAVA_PKG_STRICT} ]] ; then
		# Mark this binary early to run it now.
		pax-mark m ./bin/javap || die

		eqawarn "Ensure that this only calls trackJavaUsage(). If not, see bug #559936."
		eqawarn
		eqawarn "$(./bin/javap -J-Duser.home=${T} -c jdk.internal.vm.PostVMInitHook || die)"
	fi
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"

	# Create files used as storage for system preferences.
	mkdir .systemPrefs || die
	touch .systemPrefs/.system.lock || die
	touch .systemPrefs/.systemRootModFile || die

	if ! use alsa ; then
		rm -vf lib/libjsoundalsa.* || die
	fi

	if ! use commercial; then
		rm -vfr lib/missioncontrol lib/jfr* || die
	fi

	if use headless-awt ; then
		rm -vf lib/lib*{[jx]awt,splashscreen}* \
		   bin/{javaws,policytool} \
		   bin/appletviewer || die
	fi

	if ! use javafx ; then
		rm -vf lib/lib*{decora,fx,glass,prism}* \
		   lib/libgstreamer-lite.* lib/*fx* \
		   bin/javapackager jmods/javafx* || die
	fi

	if ! use nsplugin ; then
		rm -vf lib/libnpjp2.* || die
	else
		local nsplugin=$(echo lib/libnpjp2.*)
	fi

	# Even though plugins linked against multiple ffmpeg versions are
	# provided, they generally lag behind what Gentoo has available.
	rm -vf lib/libavplugin* || die

	dodoc legal/java.base/COPYRIGHT
	dodir "${dest}"
	cp -pPR conf bin include lib jmods "${ddest}" || die

	if use examples && has ${ARCH} "${DEMOS_AVAILABLE[@]}" ; then
		cp -pPR demo sample "${ddest}" || die
	fi

	if use nsplugin ; then
		local nsplugin_link=${nsplugin##*/}
		nsplugin_link=${nsplugin_link/./-${PN}-${SLOT}.}
		dosym "${dest}/${nsplugin}" "/usr/$(get_libdir)/nsbrowser/plugins/${nsplugin_link}"
	fi

	if use source ; then
		cp -v lib/src.zip "${ddest}" || die
	fi

	if [[ -d lib/desktop ]] ; then
		# Install desktop file for the Java Control Panel.
		# Using ${PN}-${SLOT} to prevent file collision with jdk and or
		# other slots.  make_desktop_entry can't be used as ${P} would
		# end up in filename.
		newicon lib/desktop/icons/hicolor/48x48/apps/sun-jcontrol.png \
			sun-jcontrol-${PN}-${SLOT}.png || die
		sed -e "s#Name=.*#Name=Java Control Panel for Oracle JDK ${SLOT}#" \
			-e "s#Exec=.*#Exec=/opt/${P}/jdk/bin/jcontrol#" \
			-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}#" \
			-e "s#Application;##" \
			-e "/Encoding/d" \
			lib/desktop/applications/sun_java.desktop \
			> "${T}"/jcontrol-${PN}-${SLOT}.desktop || die
		domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop
	fi

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

	if use x64-macos ; then
		# Fix miscellaneous install_name issues.
		local lib
		for lib in decora_sse glass prism_{common,es2,sw} ; do
			lib=lib${lib}.dylib
			einfo "Fixing self-reference of ${lib}"
			install_name_tool \
				-id "${EPREFIX}${dest}/jre/lib/${lib}" \
				"${ddest}"/jre/lib/${lib} || die
		done
	fi

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
