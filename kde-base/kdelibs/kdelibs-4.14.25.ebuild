# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

CMAKE_MIN_VERSION="3.3.1-r1"
CPPUNIT_REQUIRED="optional"
DECLARATIVE_REQUIRED="always"
KDE_HANDBOOK="optional"
OPENGL_REQUIRED="optional"
WEBKIT_REQUIRED="optional"
inherit kde4-base fdo-mime multilib toolchain-funcs flag-o-matic

APPS_VERSION="16.08.2" # Don't forget to bump this

DESCRIPTION="KDE libraries needed by all KDE programs"
[[ ${KDE_BUILD_TYPE} != live ]] && \
SRC_URI="mirror://kde/stable/applications/${APPS_VERSION}/src/${P}.tar.xz"

KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
LICENSE="LGPL-2.1"
IUSE="cpu_flags_x86_3dnow acl altivec +bzip2 +crypt debug doc fam jpeg2k
kerberos libressl lzma cpu_flags_x86_mmx nls openexr +policykit spell
cpu_flags_x86_sse cpu_flags_x86_sse2 ssl +udev +udisks +upower zeroconf"

REQUIRED_USE="
	udisks? ( udev )
	upower? ( udev )
"

# needs the kate regression testsuite from svn
RESTRICT="test"

COMMONDEPEND="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
	>=dev-libs/libattica-0.4.2
	dev-libs/libdbusmenu-qt[qt4]
	dev-libs/libpcre[unicode]
	dev-libs/libxml2
	dev-libs/libxslt
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/giflib:=
	media-libs/libpng:0=
	media-libs/phonon[qt4]
	sys-libs/zlib
	virtual/jpeg:0
	x11-misc/shared-mime-info
	acl? ( virtual/acl )
	!aqua? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libXcursor
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXfixes
		x11-libs/libXft
		x11-libs/libXpm
		x11-libs/libXrender
		x11-libs/libXScrnSaver
		x11-libs/libXtst
		!kernel_SunOS? (
			|| (
				sys-libs/libutempter
				>=sys-freebsd/freebsd-lib-9.0
			)
		)
	)
	bzip2? ( app-arch/bzip2 )
	crypt? ( app-crypt/qca:2[qt4] )
	fam? ( virtual/fam )
	jpeg2k? ( media-libs/jasper:= )
	kerberos? ( virtual/krb5 )
	openexr? (
		media-libs/openexr:=
		media-libs/ilmbase:=
	)
	policykit? ( sys-auth/polkit-qt[qt4] )
	spell? ( app-text/enchant )
	ssl? (
		libressl? ( dev-libs/libressl:0= )
		!libressl? ( dev-libs/openssl:0= )
	)
	udev? ( virtual/udev )
	zeroconf? ( net-dns/avahi[mdnsresponder-compat] )
"
DEPEND="${COMMONDEPEND}
	doc? ( app-doc/doxygen )
	nls? ( virtual/libintl )
"
RDEPEND="${COMMONDEPEND}
	!dev-qt/qtphonon
	>=app-crypt/gnupg-2.0.11
	app-misc/ca-certificates
	$(add_kdebase_dep kde-env '' 4.14.3)
	sys-apps/dbus[X]
	!aqua? (
		udisks? ( sys-fs/udisks:2 )
		x11-apps/iceauth
		x11-apps/rgb
		x11-misc/xdg-utils
		upower? ( || ( >=sys-power/upower-0.9.23 sys-power/upower-pm-utils ) )
	)
	udev? ( app-misc/media-player-info )
"
PDEPEND="
	$(add_kdebase_dep katepart '' 4.14.3)
	|| (
		$(add_kdeapps_dep kfmclient '' 4.14.3)
		x11-misc/xdg-utils
	)
	handbook? ( kde-apps/khelpcenter:* )
	policykit? ( || (
		>=sys-auth/polkit-kde-agent-0.99
		kde-plasma/polkit-kde-agent
	) )
"

PATCHES=(
	"${FILESDIR}/dist/01_gentoo_set_xdg_menu_prefix-1.patch"
	"${FILESDIR}/dist/02_gentoo_append_xdg_config_dirs-1.patch"
	"${FILESDIR}/${PN}-4.14.5-fatalwarnings.patch"
	"${FILESDIR}/${PN}-4.14.5-mimetypes.patch"
	"${FILESDIR}/${PN}-4.4.90-xslt.patch"
	"${FILESDIR}/${PN}-4.6.3-no_suid_kdeinit.patch"
	"${FILESDIR}/${PN}-4.8.1-norpath.patch"
	"${FILESDIR}/${PN}-4.9.3-werror.patch"
	"${FILESDIR}/${PN}-4.10.0-udisks.patch"
	"${FILESDIR}/${PN}-4.14.20-FindQt4.patch"
	"${FILESDIR}/${PN}-4.14.22-webkit.patch"
	"${FILESDIR}/${PN}-4.14.25-gcc62.patch"
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]] && tc-is-gcc; then
		[[ $(gcc-major-version) -lt 4 ]] || \
				( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -le 3 ]] ) \
			&& die "Sorry, but gcc-4.3 and earlier won't work for KDE SC 4.6 (see bug #354837)."
	fi
}

src_prepare() {
	kde4-base_src_prepare

	# Rename applications.menu (needs 01_gentoo_set_xdg_menu_prefix-1.patch to work)
	sed -e 's|FILES[[:space:]]applications.menu|FILES applications.menu RENAME kde-4-applications.menu|g' \
		-i kded/CMakeLists.txt || die "Sed on CMakeLists.txt for applications.menu failed."

	if use aqua; then
		sed -i -e \
			"s:BUNDLE_INSTALL_DIR \"/Applications:BUNDLE_INSTALL_DIR \"${EPREFIX}/${APP_BUNDLE_DIR}:g" \
			cmake/modules/FindKDE4Internal.cmake || die "failed to sed FindKDE4Internal.cmake"

		#if [[ ${CHOST} == *-darwin8 ]]; then
		sed -i -e \
			"s:set(_add_executable_param MACOSX_BUNDLE):remove(_add_executable_param MACOSX_BUNDLE):g" \
			cmake/modules/KDE4Macros.cmake || die "failed to sed KDE4Macros.cmake"
		#fi

		# solid/solid/backends/iokit doesn't properly link, so disable it.
		sed -e "s|\(APPLE\)|(FALSE)|g" -i solid/solid/CMakeLists.txt \
			|| die "disabling solid/solid/backends/iokit failed"
		sed -e "s|m_backend = .*Backends::IOKit.*;|m_backend = 0;|g" -i solid/solid/managerbase.cpp \
			|| die "disabling solid/solid/backends/iokit failed"

		# There's no fdatasync on OSX and the check fails to detect that.
		sed -e "/HAVE_FDATASYNC/ d" -i config.h.cmake \
			|| die "disabling fdatasync failed"

		# Fix nameser include to nameser8_compat
		sed -e "s|nameser8_compat.h|nameser_compat.h|g" -i kio/misc/kpac/discovery.cpp \
			|| die "fixing nameser include failed"
		append-flags -DHAVE_ARPA_NAMESER8_COMPAT_H=1

		# Try to fix kkeyserver_mac
		epatch "${FILESDIR}"/${PN}-4.3.80-kdeui_util_kkeyserver_mac.patch
	fi
}

src_configure() {
	local mycmakeargs=(
		-DWITH_HSPELL=OFF
		-DWITH_ASPELL=OFF
		-DKDE_DEFAULT_HOME=.kde4
		-DKAUTH_BACKEND=POLKITQT-1
		-DWITH_Soprano=OFF
		-DWITH_SharedDesktopOntologies=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_Strigi=ON
		-DBUILD_doc=$(usex handbook)
		-DHAVE_X86_3DNOW=$(usex cpu_flags_x86_3dnow)
		-DHAVE_PPC_ALTIVEC=$(usex altivec)
		-DHAVE_X86_MMX=$(usex cpu_flags_x86_mmx)
		-DHAVE_X86_SSE=$(usex cpu_flags_x86_sse)
		-DHAVE_X86_SSE2=$(usex cpu_flags_x86_sse2)
		-DWITH_ACL=$(usex acl)
		-DWITH_BZip2=$(usex bzip2)
		-DWITH_QCA2=$(usex crypt)
		-DWITH_FAM=$(usex fam)
		-DWITH_Jasper=$(usex jpeg2k)
		-DWITH_GSSAPI=$(usex kerberos)
		-DWITH_LibLZMA=$(usex lzma)
		-DWITH_Libintl=$(usex nls)
		-DWITH_OpenEXR=$(usex openexr)
		-DWITH_OpenGL=$(usex opengl)
		-DWITH_PolkitQt-1=$(usex policykit)
		-DWITH_ENCHANT=$(usex spell)
		-DWITH_OpenSSL=$(usex ssl)
		-DWITH_UDev=$(usex udev)
		-DWITH_SOLID_UDISKS2=$(usex udisks)
		-DWITH_Avahi=$(usex zeroconf)
		-DWITH_KDEWEBKIT=$(usex webkit)
	)

	use zeroconf || mycmakeargs+=( -DWITH_DNSSD=OFF )

	kde4-base_src_configure
}

src_compile() {
	kde4-base_src_compile

	# The building of apidox is not managed anymore by the build system
	if use doc; then
		einfo "Building API documentation"
		cd "${S}"/doc/api/
		./doxygen.sh "${S}" || die "APIDOX generation failed"
	fi
}

src_install() {
	kde4-base_src_install

	# use system certificates
	rm -f "${ED}"/usr/share/apps/kssl/ca-bundle.crt || die
	dosym /etc/ssl/certs/ca-certificates.crt /usr/share/apps/kssl/ca-bundle.crt

	if use doc; then
		einfo "Installing API documentation. This could take a bit of time."
		cd "${S}"/doc/api/
		docinto /HTML/en/kdelibs-apidox
		dohtml -r ${P}-apidocs/*
	fi

	if use aqua; then
		einfo "fixing ${PN} plugins"

		local _PV=${PV:0:3}.0
		local _dir=${EPREFIX}/usr/$(get_libdir)/kde4/plugins/script

		install_name_tool -id \
			"${_dir}/libkrossqtsplugin.${_PV}.dylib" \
			"${D}/${_dir}/libkrossqtsplugin.${_PV}.dylib" \
			|| die "failed fixing libkrossqtsplugin.${_PV}.dylib"

		einfo "fixing ${PN} cmake detection files"
		#sed -i -e \
		#	"s:if (HAVE_XKB):if (HAVE_XKB AND NOT APPLE):g" \
		echo -e "set(XKB_FOUND FALSE)\nset(HAVE_XKB FALSE)" > \
			"${ED}"/usr/share/apps/cmake/modules/FindXKB.cmake \
			|| die "failed fixing FindXKB.cmake"
	fi

	einfo Installing environment file.
	# Since 44qt4 is sourced earlier QT_PLUGIN_PATH is defined.
	echo "COLON_SEPARATED=QT_PLUGIN_PATH" > "${T}/77kde"
	echo "QT_PLUGIN_PATH=${EPREFIX}/usr/$(get_libdir)/kde4/plugins" >> "${T}/77kde"
	doenvd "${T}/77kde"
}

pkg_postinst() {
	fdo-mime_mime_database_update

	if use zeroconf; then
		echo
		elog "To make zeroconf support available in KDE make sure that the avahi daemon"
		elog "is running."
		echo
		einfo "If you also want to use zeroconf for hostname resolution, emerge sys-auth/nss-mdns"
		einfo "and enable multicast dns lookups by editing the 'hosts:' line in /etc/nsswitch.conf"
		einfo "to include 'mdns', e.g.:"
		einfo "	hosts: files mdns dns"
		echo
	fi

	kde4-base_pkg_postinst
}

pkg_prerm() {
	# Remove ksycoca4 global database
	rm -f "${EROOT}${PREFIX}"/share/kde4/services/ksycoca4
}

pkg_postrm() {
	fdo-mime_mime_database_update

	kde4-base_pkg_postrm
}
