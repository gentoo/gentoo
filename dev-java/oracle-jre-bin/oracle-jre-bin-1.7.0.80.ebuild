# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/oracle-jre-bin/oracle-jre-bin-1.7.0.80.ebuild,v 1.3 2015/04/17 21:22:41 ago Exp $

EAPI="5"

inherit java-vm-2 eutils prefix versionator

MY_PV="$(get_version_component_range 2)u$(get_version_component_range 4)"
S_PV="$(replace_version_separator 3 '_')"

X86_AT="jre-${MY_PV}-linux-i586.tar.gz"
AMD64_AT="jre-${MY_PV}-linux-x64.tar.gz"

# This URIs need updating when bumping!
JRE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jre7-downloads-1880261.html#jre-${MY_PV}-oth-JPR"
JCE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jce-7-download-432124.html"

JCE_DIR="UnlimitedJCEPolicy"
JCE_FILE="${JCE_DIR}JDK7.zip"

DESCRIPTION="Oracle's Java SE Runtime Environment"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
SRC_URI="
	x86? ( ${X86_AT} )
	amd64? ( ${AMD64_AT} )
	jce? ( ${JCE_FILE} )"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.7"
KEYWORDS="amd64 x86"
IUSE="X alsa fontconfig jce nsplugin pax_kernel selinux"

RESTRICT="fetch strip"
QA_PREBUILT="*"

COMMON_DEP=""
RDEPEND="${COMMON_DEP}
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libX11
	)
	alsa? ( media-libs/alsa-lib )
	fontconfig? ( media-libs/fontconfig )
	!prefix? ( sys-libs/glibc )
	selinux? ( sec-policy/selinux-java )"
# scanelf won't create a PaX header, so depend on paxctl to avoid fallback
# marking. #427642
DEPEND="${COMMON_DEP}
	jce? ( app-arch/unzip )
	pax_kernel? ( sys-apps/paxctl )"

S="${WORKDIR}/jre${S_PV}"

pkg_nofetch() {
	if use x86; then
		AT=${X86_AT}
	elif use amd64; then
		AT=${AMD64_AT}
	fi

	einfo "Please download '${AT}' from:"
	einfo "'${JRE_URI}'"
	einfo "and move it to '${DISTDIR}'"

	if use jce; then
		einfo "Also download '${JCE_FILE}' from:"
		einfo "'${JCE_URI}'"
		einfo "and move it to '${DISTDIR}'"
	fi

	einfo
	einfo "If the above mentioned urls do not point to the correct version anymore,"
	einfo "please download the files from Oracle's java download archive:"
	einfo
	einfo "   http://www.oracle.com/technetwork/java/javase/downloads/java-archive-downloads-javase7-521261.html#jre-${MY_PV}-oth-JPR"
	einfo
}

src_prepare() {
	if use jce; then
		mv "${WORKDIR}"/${JCE_DIR} lib/security/ || die
	fi
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest}"

	# Create files used as storage for system preferences.
	mkdir .systemPrefs || die
	touch .systemPrefs/.system.lock || die
	touch .systemPrefs/.systemRootModFile || die

	# We should not need the ancient plugin for Firefox 2 anymore, plus it has
	# writable executable segments
	if use x86; then
		rm -vf lib/i386/libjavaplugin_oji.so \
			lib/i386/libjavaplugin_nscp*.so
		rm -vrf plugin/i386
	fi
	# Without nsplugin flag, also remove the new plugin
	local arch=${ARCH};
	use x86 && arch=i386;
	if ! use nsplugin; then
		rm -vf lib/${arch}/libnpjp2.so \
			lib/${arch}/libjavaplugin_jni.so
	fi

	dodir "${dest}"
	cp -pPR bin lib man "${ddest}" || die

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

	# Remove empty dirs we might have copied
	find "${D}" -type d -empty -exec rmdir -v {} + || die

	dodoc COPYRIGHT README

	if use jce; then
		dodir ${dest}/lib/security/strong-jce
		mv "${ddest}"/lib/security/US_export_policy.jar \
			"${ddest}"/lib/security/strong-jce || die
		mv "${ddest}"/lib/security/local_policy.jar \
			"${ddest}"/lib/security/strong-jce || die
		dosym "${dest}"/lib/security/${JCE_DIR}/US_export_policy.jar \
			"${dest}"/lib/security/US_export_policy.jar
		dosym "${dest}"/lib/security/${JCE_DIR}/local_policy.jar \
			"${dest}"/lib/security/local_policy.jar
	fi

	if use nsplugin; then
		install_mozilla_plugin "${dest}"/lib/${arch}/libnpjp2.so
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
	# http://docs.oracle.com/javase/7/docs/technotes/guides/intl/fontconfig.html
	rm "${ddest}"/lib/fontconfig.* || die
	if ! use fontconfig; then
		cp "${FILESDIR}"/fontconfig.Gentoo.properties "${T}"/fontconfig.properties || die
		eprefixify "${T}"/fontconfig.properties
		insinto "${dest}"/lib/
		doins "${T}"/fontconfig.properties
	fi

	set_java_env
	java-vm_revdep-mask
	java-vm_sandbox-predict /dev/random /proc/self/coredump_filter
}
