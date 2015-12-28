# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-vm-2 multilib prefix toolchain-funcs versionator

dist="https://dev.gentoo.org/~chewi/distfiles"
TARBALL_VERSION="${PV}"

DESCRIPTION="A Gentoo-made binary build of the IcedTea JDK"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="doc? ( ${dist}/${PN}-doc-${TARBALL_VERSION}.tar.xz )
	source? ( ${dist}/${PN}-src-${TARBALL_VERSION}.tar.xz )"

for arch in amd64 arm ppc ppc64 x86; do
	SRC_URI+="
		${arch}? (
			${dist}/${PN}-core-${TARBALL_VERSION}-${arch}.tar.xz
			examples? ( ${dist}/${PN}-examples-${TARBALL_VERSION}-${arch}.tar.xz )
		)"
done

LICENSE="GPL-2-with-linking-exception"
SLOT="7"
KEYWORDS="-* amd64 ~arm ppc ~ppc64 x86"

IUSE="+alsa cjk +cups doc examples +gtk headless-awt nsplugin nss pulseaudio selinux source webstart"
REQUIRED_USE="gtk? ( !headless-awt ) nsplugin? ( !headless-awt )"

RESTRICT="preserve-libs strip"
QA_PREBUILT="opt/.*"

# gsettings-desktop-schemas is needed for native proxy support. #431972
RDEPEND=">=dev-libs/glib-2.42:2
	>=dev-libs/nss-3.16.1-r1
	>=dev-libs/nspr-4.10
	>=gnome-base/gsettings-desktop-schemas-3.12.2
	media-fonts/dejavu
	>=media-libs/fontconfig-2.11:1.0
	>=media-libs/freetype-2.5.5:2
	>=media-libs/lcms-2.6:2
	>=sys-devel/gcc-4.9.3
	>=sys-libs/glibc-2.21
	>=sys-libs/zlib-1.2.8-r1
	virtual/jpeg:62
	alsa? ( >=media-libs/alsa-lib-1.0 )
	!headless-awt? (
		>=media-libs/giflib-4.1.6-r1
		media-libs/libpng:0/16
		>=x11-libs/libX11-1.6
		>=x11-libs/libXext-1.3
		>=x11-libs/libXi-1.7
		>=x11-libs/libXrender-0.9.8
		>=x11-libs/libXtst-1.2
	)
	cjk? (
		media-fonts/arphicfonts
		media-fonts/baekmuk-fonts
		media-fonts/lklug
		media-fonts/lohit-fonts
		media-fonts/sazanami
	)
	cups? ( >=net-print/cups-2.0 )
	gtk? (
		>=dev-libs/atk-2.16.0
		>=x11-libs/cairo-1.14.2
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.24:2
		>=x11-libs/pango-1.36
	)
	selinux? ( sec-policy/selinux-java )"

DEPEND="!arm? ( dev-util/patchelf )"

PDEPEND="webstart? ( dev-java/icedtea-web:0[icedtea7] )
	nsplugin? ( dev-java/icedtea-web:0[icedtea7,nsplugin] )
	pulseaudio? ( dev-java/icedtea-sound )"

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]]; then
		die "These binaries require a hardfloat system."
	fi
}

src_prepare() {
	if ! use alsa; then
		rm -v jre/lib/$(get_system_arch)/libjsoundalsa.* || die
	fi

	if use headless-awt; then
		rm -vr jre/lib/$(get_system_arch)/{xawt,libsplashscreen.*} \
		   {,jre/}bin/policytool bin/appletviewer || die
	fi

	if ! use gtk; then
		rm -v jre/lib/$(get_system_arch)/libjavagtk.* || die
	fi

	# NSS is already required because of SunEC. The nss flag in the
	# icedtea package just comments or uncomments this line.
	sed -i "/=sun\.security\.pkcs11\.SunPKCS11/s/^#*$(usex nss '/' '/#')/" jre/lib/security/java.security || die

	if [[ -n "${EPREFIX}" ]]; then
		# The binaries are built on a non-prefixed system so the
		# fontconfig needs to have prefixes inserted.
		sed -i 's:=/:=@GENTOO_PORTAGE_EPREFIX@/:' jre/lib/fontconfig.Gentoo.properties || die
		eprefixify jre/lib/fontconfig.Gentoo.properties
	fi

	# Fix the RPATHs, except on arm.
	# https://bugs.gentoo.org/show_bug.cgi?id=543658#c3
	# https://github.com/NixOS/patchelf/issues/8
	if use arm; then
		ewarn "The RPATHs on these binaries are normally modified to avoid"
		ewarn "conflicts with an icedtea installation built from source. This"
		ewarn "is currently not possible on ARM so please refrain from"
		ewarn "installing dev-java/icedtea on the same system."
	else
		local old="/usr/$(get_libdir)/icedtea${SLOT}"
		local new="${EPREFIX}/opt/${P}"
		local elf rpath

		for elf in $(find -type f -executable ! -name "*.cgi" || die); do
			rpath=$(patchelf --print-rpath "${elf}" || die "patchelf ${elf}")

			if [[ -n "${rpath}" ]]; then
				patchelf --set-rpath "${rpath//${old}/${new}}" "${elf}" || die "patchelf ${elf}"
			fi
		done
	fi
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"
	dodir "${dest}"

	# doins doesn't preserve executable bits.
	cp -pRP bin include jre lib man "${ddest}" || die

	dodoc doc/{ASSEMBLY_EXCEPTION,AUTHORS,NEWS,README,THIRD_PARTY_README}
	use doc && dodoc -r doc/html

	if use examples; then
		cp -pRP demo sample "${ddest}" || die
	fi

	if use source; then
		cp src.zip "${ddest}" || die
	fi

	if use webstart || use nsplugin; then
		dosym /usr/libexec/icedtea-web/itweb-settings "${dest}/bin/itweb-settings"
		dosym /usr/libexec/icedtea-web/itweb-settings "${dest}/jre/bin/itweb-settings"
	fi
	if use webstart; then
		dosym /usr/libexec/icedtea-web/javaws "${dest}/bin/javaws"
		dosym /usr/libexec/icedtea-web/javaws "${dest}/jre/bin/javaws"
	fi

	# Both icedtea itself and the icedtea ebuild set PAX markings but we
	# disable them for the icedtea-bin build because the line below will
	# respect end-user settings when icedtea-bin is actually installed.
	java-vm_set-pax-markings "${ddest}"

	set_java_env
	java-vm_revdep-mask "${dest}"
	java-vm_sandbox-predict /proc/self/coredump_filter
}

pkg_postinst() {
	if use nsplugin; then
		if [[ -n ${REPLACING_VERSIONS} ]] && ! version_is_at_least 7.2.4.3 ${REPLACING_VERSIONS} ]]; then
			elog "The nsplugin for icedtea-bin is now provided by the icedtea-web package"
			elog "If you had icedtea-bin-7 nsplugin selected, you may see a related error below"
			elog "The switch should complete properly during the subsequent installation of icedtea-web"
			elog "Afterwards you may verify the output of 'eselect java-nsplugin list' and adjust accordingly'"
		fi
	fi

	# Set as default VM if none exists
	java-vm-2_pkg_postinst
}
