# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: USE=java isn't really doing anything here right now. It also
# uses jre:11 which may be unnecessary.
inherit java-pkg-opt-2 prefix unpacker xdg

DESCRIPTION="A full office productivity suite. Binary package"
HOMEPAGE="https://www.libreoffice.org"
SRC_URI_AMD64="
	https://download.documentfoundation.org/libreoffice/stable/${PV}/deb/x86_64/LibreOffice_${PV}_Linux_x86-64_deb.tar.gz
"
SRC_URI="
	amd64? ( ${SRC_URI_AMD64} )
"
S="${WORKDIR}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="java gnome python"

RDEPEND="
	acct-group/libreoffice
	acct-user/libreoffice
	app-accessibility/at-spi2-core:2
	app-arch/unzip
	app-arch/zip
	app-crypt/mit-krb5
	dev-libs/glib:2
	dev-libs/gobject-introspection
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	gnome-base/dconf
	media-fonts/liberation-fonts
	media-libs/fontconfig
	media-libs/freetype
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	media-libs/mesa[egl(+)]
	net-dns/avahi
	net-print/cups
	sys-apps/dbus
	sys-devel/gcc:*
	sys-fs/e2fsprogs
	sys-libs/glibc
	sys-libs/zlib
	virtual/libcrypt
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[X]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/pango
	gnome? (
		dev-libs/glib:2
		>=gnome-base/dconf-0.40.0
		gnome-extra/evolution-data-server
	)
	|| ( x11-misc/xdg-utils kde-plasma/kde-cli-tools )
	java? ( virtual/jre:11 )
"
RESTRICT="test strip"

QA_PREBUILT="opt/* usr/*"

src_unpack() {
	default

	BINPKG_BASE=$(find "${WORKDIR}" -mindepth 1 -maxdepth 1 -name 'LibreOffice_*' -type d -print || die)
	BINPKG_BASE="${BINPKG_BASE##${WORKDIR}}"
	[[ -z ${BINPKG_BASE} ]] && die "Failed to detect binary package directory!"

	# We don't package Firebird anymore
	rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-firebird*_amd64.deb || die

	if ! use gnome ; then
		rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-gnome-integration*_amd64.deb || die
	fi

	# Requires KF5 as of 25.2.0, so we choose not to use it.
	rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-kde-integration*_amd64.deb || die

	# Bundled Python is used (3.10 as of 25.2.0), so no need for system dependency.
	if ! use python ; then
		rm "${WORKDIR}"/${BINPKG_BASE}/DEBS/libobasis${PV%*.*}-python-script-provider*_amd64.deb || die
	fi

	# The downloaded .deb has a DEBS/ directory with e.g. libreoffice25.2_25.2.0.3-3_amd64.deb
	# and many other .debs for each component.
	readarray -t -d '' debs < <(find "${WORKDIR}" -name '*.deb' -type f -print0 || die)

	local deb
	for deb in "${debs[@]}" ; do
		unpack_deb "${deb}"
	done
}

src_prepare() {
	default

	cat <<-EOF > "${T}"/50-${PN} || die
	SEARCH_DIRS_MASK="@GENTOO_PORTAGE_EPREFIX@/opt/libreoffice${PV%*.*}"
	EOF
	eprefixify "${T}"/50-${PN}
}

src_install() {
	dodir /usr /opt
	mv "${S}"/usr/local/* "${S}"/usr || die
	cp -aR "${S}"/opt/* "${ED}"/opt/ || die
	cp -aR "${S}"/usr/* "${ED}"/usr/ || die
	rmdir "${ED}"/usr/local || die

	# prevent revdep-rebuild from attempting to rebuild all the time
	insinto /etc/revdep-rebuild
	doins "${T}/50-${PN}"
}
