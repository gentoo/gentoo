# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-vm-2 eutils prefix versionator

# This URIs need to be updated when bumping!
JRE_URI="http://www.oracle.com/technetwork/java/javase/downloads/jre6downloads-1902815.html"

MY_PV="$(get_version_component_range 2)u$(get_version_component_range 4)"
S_PV="$(replace_version_separator 3 '_')"

X86_AT="jre-${MY_PV}-linux-i586.bin"
AMD64_AT="jre-${MY_PV}-linux-x64.bin"
IA64_AT="jre-${MY_PV}-linux-ia64.bin"

DESCRIPTION="Oracle's Java SE Runtime Environment"
HOMEPAGE="http://www.oracle.com/technetwork/java/javase/"
SRC_URI="
	amd64? ( ${AMD64_AT} )
	ia64? ( ${IA64_AT} )
	x86? ( ${X86_AT} )"

LICENSE="Oracle-BCLA-JavaSE"
SLOT="1.6"
KEYWORDS="amd64 x86"
IUSE="X alsa jce nsplugin pax_kernel selinux"

RESTRICT="fetch strip"
QA_PREBUILT="*"

RDEPEND="
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrender
		x11-libs/libXtst
		x11-libs/libX11
	)
	alsa? ( media-libs/alsa-lib )
	jce? ( dev-java/sun-jce-bin:1.6 )
	!prefix? ( sys-libs/glibc )
	selinux? ( sec-policy/selinux-java )"
# scanelf won't create a PaX header, so depend on paxctl to avoid fallback
# marking. #427642
DEPEND="
	pax_kernel? ( sys-apps/paxctl )
	selinux? ( sec-policy/selinux-java )"

S="${WORKDIR}/jre${S_PV}"

pkg_nofetch() {
	if use x86; then
		AT=${X86_AT}
	elif use amd64; then
		AT=${AMD64_AT}
	elif use ia64; then
		AT=${IA64_AT}
	fi

	einfo "Due to Oracle no longer providing the distro-friendly DLJ bundles, the package"
	einfo "has become fetch restricted again. Alternatives are switching to"
	einfo "dev-java/icedtea-bin:6 or the source-based dev-java/icedtea:6"
	einfo ""
	einfo "Please download '${AT}' from:"
	einfo "'${JRE_URI}'"
	einfo "and move it to '${DISTDIR}'"
}

src_unpack() {
	sh "${DISTDIR}"/${A} -noregister || die "Failed to unpack"
}

src_compile() {
	# This needs to be done before CDS - #215225
	java-vm_set-pax-markings "${S}"

	# see bug #207282
	einfo "Creating the Class Data Sharing archives"
	case ${ARCH} in
		ia64)
			bin/java -client -Xshare:dump || die
			;;
		x86)
			bin/java -client -Xshare:dump || die
			# limit heap size for large memory on x86 #405239
			# this is a workaround and shouldn't be needed.
			bin/java -server -Xmx64m -Xshare:dump || die
			;;
		*)
			bin/java -server -Xshare:dump || die
			;;
	esac
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest}"

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

	# Remove empty dirs we might have copied
	find "${D}" -type d -empty -exec rmdir {} + || die

	dodoc COPYRIGHT README

	if use jce; then
		dodir "${dest}"/lib/security/strong-jce
		mv "${ddest}"/lib/security/US_export_policy.jar \
			"${ddest}"/lib/security/strong-jce || die
		mv "${ddest}"/lib/security/local_policy.jar \
			"${ddest}"/lib/security/strong-jce || die
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/US_export_policy.jar \
			"${dest}"/lib/security/US_export_policy.jar
		dosym /opt/sun-jce-bin-1.6.0/jre/lib/security/unlimited-jce/local_policy.jar \
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
	sed -e "s#Name=.*#Name=Java Control Panel for Oracle JDK ${SLOT} (${PN})#" \
		-e "s#Exec=.*#Exec=${dest}/bin/jcontrol#" \
		-e "s#Icon=.*#Icon=sun-jcontrol-${PN}-${SLOT}#" \
		-e "s#Application;##" \
		-e "/Encoding/d" \
		lib/desktop/applications/sun_java.desktop > \
		"${T}"/jcontrol-${PN}-${SLOT}.desktop || die
	domenu "${T}"/jcontrol-${PN}-${SLOT}.desktop

	# http://docs.oracle.com/javase/6/docs/technotes/guides/intl/fontconfig.html
	rm "${ddest}"/lib/fontconfig.* || die
	cp "${FILESDIR}"/fontconfig.Gentoo.properties-r1 "${T}"/fontconfig.properties || die
	eprefixify "${T}"/fontconfig.properties
	insinto "${dest}"/lib/
	doins "${T}"/fontconfig.properties

	set_java_env "${FILESDIR}/${VMHANDLE}.env-r1"
	java-vm_revdep-mask
}

pkg_postinst() {
	java-vm-2_pkg_postinst

	elog "If you want Oracles JRE 7 'emerge oracle-jre-bin' instead."
}
