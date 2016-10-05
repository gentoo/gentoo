# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MULTILIB_COMPAT=( abi_x86_{32,64} )
KEYWORDS="-* amd64 x86"

inherit java-vm-2 multilib-build prefix toolchain-funcs

BASE_URI="https://dev.gentoo.org/~chewi/distfiles"
SRC_URI="doc? ( ${BASE_URI}/${PN}-doc-${PV}.tar.xz )
	source? ( ${BASE_URI}/${PN}-src-${PV}.tar.xz )
	multilib? ( amd64? ( abi_x86_32? ( ${BASE_URI}/${PN}-core-${PV}-x86.tar.xz ) ) )"

for abi in amd64 x86; do
	SRC_URI+="
		${abi}? (
			${BASE_URI}/${PN}-core-${PV}-${abi}.tar.xz
			examples? ( ${BASE_URI}/${PN}-examples-${PV}-${abi}.tar.xz )
		)"
done

DESCRIPTION="A Gentoo-made binary build of the IcedTea JDK"
HOMEPAGE="http://icedtea.classpath.org"
LICENSE="GPL-2-with-classpath-exception"
SLOT="7"

IUSE="+alsa cjk +cups doc examples +gtk headless-awt multilib nsplugin nss pulseaudio selinux source +webstart"
REQUIRED_USE="gtk? ( !headless-awt ) nsplugin? ( !headless-awt )"

RESTRICT="preserve-libs strip"
QA_PREBUILT="opt/.*"

RDEPEND=">=dev-libs/glib-2.42:2%
	>=dev-libs/nss-3.16.1-r1%
	>=dev-libs/nspr-4.10%
	>=media-libs/fontconfig-2.11:1.0%
	>=media-libs/freetype-2.5.5:2%
	>=media-libs/lcms-2.6:2%
	>=sys-libs/zlib-1.2.8-r1%
	virtual/jpeg:62%
	alsa? ( >=media-libs/alsa-lib-1.0% )
	cups? ( >=net-print/cups-2.0% )
	gtk? (
		>=dev-libs/atk-2.16.0%
		>=x11-libs/cairo-1.14.2%
		x11-libs/gdk-pixbuf:2%
		>=x11-libs/gtk+-2.24:2%
		>=x11-libs/pango-1.36%
	)
	!headless-awt? (
		>=media-libs/giflib-4.1.6-r1%
		media-libs/libpng:0/16%
		>=x11-libs/libX11-1.6%
		>=x11-libs/libXcomposite-0.4%
		>=x11-libs/libXext-1.3%
		>=x11-libs/libXi-1.7%
		>=x11-libs/libXrender-0.9.8%
		>=x11-libs/libXtst-1.2%
	)"

# gsettings-desktop-schemas is needed for native proxy support. #431972
RDEPEND=">=gnome-base/gsettings-desktop-schemas-3.12.2
	media-fonts/dejavu
	>=sys-devel/gcc-4.9.3[multilib?]
	>=sys-libs/glibc-2.22[multilib?]
	cjk? (
		media-fonts/arphicfonts
		media-fonts/baekmuk-fonts
		media-fonts/lklug
		media-fonts/lohit-fonts
		media-fonts/sazanami
	)
	selinux? ( sec-policy/selinux-java )
	multilib? ( ${RDEPEND//%/[${MULTILIB_USEDEP}]} )
	!multilib? ( ${RDEPEND//%/} )"

DEPEND="!arm? ( dev-util/patchelf )"

PDEPEND="webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )
	pulseaudio? ( dev-java/icedtea-sound )"

S="${WORKDIR}"

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]]; then
		die "These binaries require a hardfloat system."
	fi
}

src_prepare() {
	if ! use alsa; then
		rm -v */jre/lib/*/libjsoundalsa.* || die
	fi

	if use headless-awt; then
		rm -vr */jre/lib/*/{xawt,libsplashscreen.*} \
		   */{,jre/}bin/policytool */bin/appletviewer || die
	fi

	if ! use gtk; then
		rm -v */jre/lib/*/libjavagtk.* || die
	fi

	local lib=${P}-${ABI}/jre/lib

	# NSS is already required because of SunEC. The nss flag in the
	# icedtea package just comments or uncomments this line.
	sed -i "/=sun\.security\.pkcs11\.SunPKCS11/s/^#*$(usex nss '/' '/#')/" \
		${lib}/security/java.security || die

	if [[ -n "${EPREFIX}" ]]; then
		# The binaries are built on a non-prefixed system so the
		# fontconfig needs to have prefixes inserted.
		rm ${lib}/fontconfig.Gentoo.bfc || die
		hprefixify ${lib}/fontconfig.Gentoo.properties.src
		mv ${lib}/fontconfig.Gentoo.properties{.src,} || die
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

multilib_src_install() {
	local dest="/opt/${P}-${ABI}"
	dest="${dest/%-${DEFAULT_ABI}/}"
	local ddest="${ED}${dest#/}"
	dodir "${dest}"

	if multilib_is_native_abi; then
		dodoc ${P}-${ABI}/doc/{ASSEMBLY_EXCEPTION,AUTHORS,NEWS,README,THIRD_PARTY_README}
		use doc && dodoc -r ${P}/doc/html

		# doins doesn't preserve executable bits.
		cp -pRP ${P}-${ABI}/{bin,include,jre,lib,man} "${ddest}" || die

		if use examples; then
			cp -pRP ${P}-${ABI}/{demo,sample} "${ddest}" || die
		fi

		if use source; then
			cp ${P}/src.zip "${ddest}" || die
		fi

		# Use default VMHANDLE.
		java-vm_install-env "${FILESDIR}/icedtea-bin.env.sh"
	else
		local x native=$(get_system_arch ${DEFAULT_ABI})

		for x in {,/jre}/{bin,lib/$(get_system_arch)} /jre/lib/rt.jar; do
			dodir "${dest}"${x%/*}
			cp -pRP ${P}-${ABI}${x} "${ddest}"${x} || die
		done

		for x in ${P}-${DEFAULT_ABI}{,/jre}/lib/*; do
			[[ ${x##*/} = ${native} ]] && continue
			[[ -e "${ddest}"/${x#*/} ]] && continue
			dosym "${EPREFIX}"/opt/${P}/${x#*/} "${dest}"/${x#*/}
		done

		# Use ABI-suffixed VMHANDLE.
		VMHANDLE+="-${ABI}" java-vm_install-env "${FILESDIR}/icedtea-bin.env.sh"
	fi

	# Both icedtea itself and the icedtea ebuild set PAX markings but we
	# disable them for the icedtea-bin build because the line below will
	# respect end-user settings when icedtea-bin is actually installed.
	java-vm_set-pax-markings "${ddest}"

	# Each invocation appends to the config.
	java-vm_revdep-mask "${EPREFIX}${dest}"
}

src_install() {
	if use multilib; then
		multilib_foreach_abi multilib_src_install
	else
		multilib_src_install
	fi

	java-vm_sandbox-predict /proc/self/coredump_filter
}
