# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit cdrom eutils gnome2-utils multilib-build

MY_UPDATE_P="${PN}up2"
MY_UPDATE_GTK="${PN}gtk216"
MY_ZIPCODE_P="a20y1406lx"

DESCRIPTION="ATOK X3 for Linux - The most famous Japanese Input Method Engine"
HOMEPAGE="https://www.justsystems.com/jp/products/atok_linux/"
SRC_URI="https://gate.justsystems.com/download/atok/up/lin/${MY_UPDATE_P}.tar.gz
	https://gate.justsystems.com/download/atok/up/lin/${MY_UPDATE_GTK}.tar.gz
	https://gate.justsystems.com/download/zipcode/up/lin/${MY_ZIPCODE_P}.tgz"

LICENSE="ATOK MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"

RDEPEND="dev-libs/atk
	dev-libs/glib:2
	dev-libs/libxml2:2
	media-libs/fontconfig
	media-libs/libpng
	sys-apps/tcp-wrappers
	sys-libs/pam
	x11-libs/cairo
	>=x11-libs/gtk+-2.4.13:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXxf86vm
	x11-libs/libdrm
	x11-libs/pangox-compat
	amd64? (
		>=dev-libs/atk-2.10.0[abi_x86_32(-)]
		>=dev-libs/glib-2.34.3:2[abi_x86_32(-)]
		>=dev-libs/libxml2-2.9.1-r4:2[abi_x86_32(-)]
		>=media-libs/fontconfig-2.10.92[abi_x86_32(-)]
		>=media-libs/libpng-1.2.51[abi_x86_32(-)]
		>=sys-apps/tcp-wrappers-7.6.22-r1[abi_x86_32(-)]
		>=sys-libs/pam-0-r1[abi_x86_32(-)]
		>=x11-libs/cairo-1.12.14-r4[abi_x86_32(-)]
		>=x11-libs/gtk+-2.24.23:2[abi_x86_32(-)]
		>=x11-libs/libICE-1.0.8-r1[abi_x86_32(-)]
		>=x11-libs/libSM-1.2.1-r1[abi_x86_32(-)]
		>=x11-libs/libXcomposite-0.4.4-r1[abi_x86_32(-)]
		>=x11-libs/libXcursor-1.1.14[abi_x86_32(-)]
		>=x11-libs/libXdamage-1.1.4-r1[abi_x86_32(-)]
		>=x11-libs/libXext-1.3.2[abi_x86_32(-)]
		>=x11-libs/libXfixes-5.0.1[abi_x86_32(-)]
		>=x11-libs/libXft-2.3.1-r1[abi_x86_32(-)]
		>=x11-libs/libXi-1.7.2[abi_x86_32(-)]
		>=x11-libs/libXrandr-1.4.2[abi_x86_32(-)]
		>=x11-libs/libXrender-0.9.8[abi_x86_32(-)]
		>=x11-libs/libXxf86vm-1.1.3[abi_x86_32(-)]
		>=x11-libs/libdrm-2.4.46[abi_x86_32(-)]
		>=x11-libs/pangox-compat-0.0.2[abi_x86_32(-)]
	)"
S="${WORKDIR}"

EMULTILIB_PKG="true"

pkg_setup() {
	if ! cdrom_get_cds ${PN}index ; then
		die "Please mount ATOK for Linux CD-ROM or set CD_ROOT variable to the directory containing ATOK X3 for Linux."
	fi

	QA_PREBUILT="opt/${PN}/lib/server/*
		opt/${PN}/lib/client/xaux/*
		opt/${PN}/lib/client/*
		opt/${PN}/bin/*
		usr/libexec/*
		usr/bin/*
		usr/$(get_libdir)/*
		usr/$(get_libdir)/gtk-2.0/immodules/*
		usr/$(get_libdir)/iiim/le/${PN}/64/*
		usr/$(ABI=x86 get_libdir)/*
		usr/$(ABI=x86 get_libdir)/gtk-2.0/immodules/*
		usr/$(ABI=x86 get_libdir)/iiim/*
		usr/$(ABI=x86 get_libdir)/iiim/le/${PN}/*"
}

src_unpack() {
	local targets="
		IIIMF/iiimf-client-lib-trunk_r3104-js*.i386.tar.gz
		IIIMF/iiimf-gtk-trunk_r3104-js*.i386.tar.gz
		IIIMF/iiimf-protocol-lib-trunk_r3104-js*.i386.tar.gz
		IIIMF/iiimf-server-trunk_r3104-js*.i386.tar.gz
		IIIMF/iiimf-x-trunk_r3104-js*.i386.tar.gz
		IIIMF/iiimf-client-lib-devel-trunk_r3104-js*.i386.tar.gz
		IIIMF/iiimf-protocol-lib-devel-trunk_r3104-js*.i386.tar.gz
		ATOK/atokx-20.0-*.0.0.i386.tar.gz"
	#	IIIMF/iiimf-properties-trunk_r3104-js*.i386.tar.gz
	#	IIIMF/iiimf-docs-trunk_r3104-js*.i386.tar.gz
	#	IIIMF/iiimf-notuse-trunk_r3104-js*.i386.tar.gz

	if use abi_x86_64 ; then
		targets+="
			IIIMF/iiimf-client-lib-64-trunk_r3104-js*.x86_64.tar.gz
			IIIMF/iiimf-gtk-64-trunk_r3104-js*.x86_64.tar.gz
			IIIMF/iiimf-protocol-lib-64-trunk_r3104-js*.x86_64.tar.gz
			ATOK/atokx-64-20.0-*.0.0.x86_64.tar.gz"
		#	IIIMF/iiimf-client-lib-devel-64-trunk_r3104-js*.x86_64.tar.gz
		#	IIIMF/iiimf-protocol-lib-devel-64-trunk_r3104-js*.x86_64.tar.gz
		#	IIIMF/iiimf-notuse-64-trunk_r3104-js*.x86_64.tar.gz
	fi

	targets+=" ATOK/atokxup-20.0-*.0.0.i386.tar.gz"

	unpack ${MY_UPDATE_P}.tar.gz

	local i
	for i in ${targets} ; do
		if [[ -f "${S}"/${MY_UPDATE_P}/bin/${i} ]] ; then
			einfo "unpack" $(basename "${S}"/${MY_UPDATE_P}/bin/${i})
			tar xzf "${S}"/${MY_UPDATE_P}/bin/${i} || die "Failed to unpack ${i}"
		elif [[ -f "${CDROM_ROOT}"/bin/tarball/${i} ]] ; then
			einfo "unpack" $(basename "${CDROM_ROOT}"/bin/tarball/${i})
			tar xzf "${CDROM_ROOT}"/bin/tarball/${i} || die "Failed to unpack ${i}"
		else
			die "${i} not found."
		fi
	done
	unpack ${MY_UPDATE_GTK}.tar.gz
	unpack ${MY_ZIPCODE_P}.tgz
}

src_prepare() {
	if use abi_x86_64 ; then
		local lib32="$(ABI=x86 get_libdir)"
		local lib64="$(get_libdir)"
		if [[ "lib" != "${lib32}" ]] ; then
			mv usr/lib "usr/${lib32}" || die
		fi
		if [[ "lib64" != "${lib64}" ]] ; then
			mv usr/lib64 "usr/${lib64}" || die
		fi
		mkdir -p "usr/${lib64}/iiim/le/${PN}" || die
		mv "usr/${lib32}/iiim/le/${PN}/64" "usr/${lib64}/iiim/le/${PN}/64" || die
		rm "usr/${lib32}/iiim/le/${PN}/amd64" || die
		sed -e "s:/usr/lib:/usr/${lib64}:" "usr/${lib32}/libiiimcf.la" > "usr/${lib64}/libiiimcf.la" || die
		sed -e "s:/usr/lib:/usr/${lib64}:" "usr/${lib32}/libiiimp.la" > "usr/${lib64}/libiiimp.la" || die
		sed -i -e "s:/usr/lib:/usr/${lib32}:" "usr/${lib32}/libiiimcf.la" || die
		sed -i -e "s:/usr/lib:/usr/${lib32}:" "usr/${lib32}/libiiimp.la" || die
	fi
}

src_install() {
	DOCS=( ${MY_UPDATE_P}/README_UP2.txt "${CDROM_ROOT}"/doc/atok.pdf )
	HTML_DOCS=( "${CDROM_ROOT}"/readme.html )
	einstalldocs
	rm -rf ${MY_UPDATE_P}

	cp -dpR * "${ED}" || die

	# amd64 hack
	if use abi_x86_64 ; then
		local lib32="$(ABI=x86 get_libdir)"
		local lib64="$(get_libdir)"
		if [[ "${lib32}" != "${lib64}" ]] ; then
			local f
			for f in xiiimp.so xiiimp.a iiim-xbe xiiimp.so.2 xiiimp.so.2.0.0 iiimd-watchdog xiiimp.la ; do
				dosym "${EPREFIX}/usr/${lib32}/iiim/${f}" "/usr/${lib64}/iiim/${f}"
			done
			for f in ${PN}aux.so ${PN}.so ; do
				dosym "${EPREFIX}/usr/${lib32}/iiim/le/${PN}/${f}" "/usr/${lib64}/iiim/le/${PN}/${f}"
			done
			dosym "${EPREFIX}/usr/${lib64}/iiim/le/${PN}/64" "/usr/${lib32}/iiim/le/${PN}/64"
			dosym "${EPREFIX}/usr/${lib64}/iiim/le/${PN}/64" "/usr/${lib32}/iiim/le/${PN}/amd64"
		fi
	fi

	sed -e "s:@EPREFIX@:${EPREFIX}:" "${FILESDIR}/xinput-iiimf" > "${T}/iiimf.conf" || die
	insinto /etc/X11/xinit/xinput.d
	doins "${T}/iiimf.conf"
}

pkg_preinst() {
	# bug #343325
	if use abi_x86_64 && has_multilib_profile && [[ -L "${EPREFIX}/usr/$(get_libdir)/iiim" ]] ; then
		rm -f "${EPREFIX}/usr/$(get_libdir)/iiim"
	fi
}

pkg_postinst() {
	elog
	elog "To use ATOK for Linux, you need to add following to .xinitrc or .xprofile:"
	elog
	elog ". /opt/${PN}/bin/${PN}start.sh"
	elog
	multilib_foreach_abi gnome2_query_immodules_gtk2
}

pkg_postrm() {
	multilib_foreach_abi gnome2_query_immodules_gtk2
}
