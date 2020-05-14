# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit java-vm-2 multilib-build toolchain-funcs

abi_uri() {
	echo "${2-$1}? (
			${BASE_URI}/${PN}-core-${PV}${3+-r${3}}-${1}.tar.xz
			examples? ( ${BASE_URI}/${PN}-examples-${PV}${3+-r${3}}-${1}.tar.xz )
		)"
}

BASE_URI="https://dev.gentoo.org/~gyakovlev/distfiles"
SRC_URI="
	doc? ( ${BASE_URI}/${PN}-doc-${PV}.tar.xz )
	source? ( ${BASE_URI}/${PN}-src-${PV}.tar.xz )
	big-endian? ( $(abi_uri ppc64) )
	!big-endian? ( $(abi_uri ppc64le ppc64) )
	$(abi_uri amd64)
	$(abi_uri arm)
	$(abi_uri arm64)
	$(abi_uri x86)
"

DESCRIPTION="A Gentoo-made binary build of the IcedTea JDK"
HOMEPAGE="http://icedtea.classpath.org"

LICENSE="GPL-2-with-classpath-exception"
SLOT="8"
KEYWORDS="-* amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="+alsa big-endian cups doc examples +gtk headless-awt nsplugin pulseaudio selinux source webstart"

REQUIRED_USE="
	gtk? ( !headless-awt )
	nsplugin? ( !headless-awt )
"

RESTRICT="preserve-libs strip"
QA_PREBUILT="opt/.*"

DEPEND="app-arch/xz-utils"

RDEPEND="
	>=dev-libs/glib-2.60.7:2
	>=media-libs/fontconfig-2.13:1.0
	>=media-libs/freetype-2.9.1:2
	>=media-libs/lcms-2.9:2
	>=sys-apps/baselayout-java-0.1.0-r1
	>=sys-libs/zlib-1.2.11-r2
	virtual/jpeg-compat:62
	alsa? ( >=media-libs/alsa-lib-1.2 )
	cups? ( >=net-print/cups-2.0 )
	gtk? (
		>=dev-libs/atk-2.32.0
		>=x11-libs/cairo-1.16.0
		x11-libs/gdk-pixbuf:2
		>=x11-libs/gtk+-2.24:2
		>=x11-libs/pango-1.42
	)
	selinux? ( sec-policy/selinux-java )
	virtual/ttf-fonts
	!headless-awt? (
		media-libs/giflib:0/7
		=media-libs/libpng-1.6*
		>=x11-libs/libX11-1.6
		>=x11-libs/libXcomposite-0.4
		>=x11-libs/libXext-1.3
		>=x11-libs/libXi-1.7
		>=x11-libs/libXrender-0.9.10
		>=x11-libs/libXtst-1.2
	)
"

PDEPEND="
	webstart? ( >=dev-java/icedtea-web-1.6.1:0 )
	nsplugin? ( >=dev-java/icedtea-web-1.6.1:0[nsplugin] )
	pulseaudio? ( dev-java/icedtea-sound )
"

S="${WORKDIR}"

pkg_pretend() {
	if [[ "$(tc-is-softfloat)" != "no" ]]; then
		die "These binaries require a hardfloat system."
	fi
}

src_prepare() {
	default

	# I wouldn't normally use -f below but symlinks in the arm files
	# make this fail otherwise and any other approach would be tedious.

	if ! use alsa; then
		rm -fv */jre/lib/*/libjsoundalsa.* || die
	fi

	if use headless-awt; then
		rm -fvr */jre/lib/*/lib*{[jx]awt,splashscreen}* \
		   */{,jre/}bin/policytool */bin/appletviewer || die
	fi
}

src_install() {
	local dest="/opt/${P}"
	local ddest="${ED}${dest#/}"
	dodir "${dest}"

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

	# use system-wide cacert store
	rm "${ddest}"/jre/lib/security/cacerts || die
	dosym ../../../../../etc/ssl/certs/java/cacerts "${dest}"/jre/lib/security/cacerts

	java-vm_install-env "${FILESDIR}/icedtea-bin.env.sh"

	# Both icedtea itself and the icedtea ebuild set PAX markings but we
	# disable them for the icedtea-bin build because the line below will
	# respect end-user settings when icedtea-bin is actually installed.
	java-vm_set-pax-markings "${ddest}"

	# Each invocation appends to the config.
	java-vm_revdep-mask "${EPREFIX}${dest}"
	java-vm_sandbox-predict /proc/self/coredump_filter
}
