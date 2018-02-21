# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="threads,xml"

# experimental ; release ; old
# Usually the tarballs are moved a lot so this should make
# everyone happy.
DEV_URI="
	https://dev-builds.libreoffice.org/pre-releases/src
	https://download.documentfoundation.org/libreoffice/src/${PV:0:5}/
	https://download.documentfoundation.org/libreoffice/old/${PV}/
"
ADDONS_URI="https://dev-www.libreoffice.org/src/"

BRANDING="${PN}-branding-gentoo-0.8.tar.xz"
# PATCHSET="${P}-patchset-01.tar.xz"

[[ ${PV} == *9999* ]] && SCM_ECLASS="git-r3"
inherit multiprocessing autotools bash-completion-r1 check-reqs gnome2-utils java-pkg-opt-2 pax-utils python-single-r1 toolchain-funcs flag-o-matic versionator xdg-utils qmake-utils ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="A full office productivity suite"
HOMEPAGE="https://www.libreoffice.org"
SRC_URI="branding? ( https://dev.gentoo.org/~dilfridge/distfiles/${BRANDING} )"
[[ -n ${PATCHSET} ]] && SRC_URI+=" http://dev.gentooexperimental.org/~scarabeus/${PATCHSET}"

# Split modules following git/tarballs
# Core MUST be first!
# Help is used for the image generator
# Only release has the tarballs
if [[ ${PV} != *9999* ]]; then
	for i in ${DEV_URI}; do
		SRC_URI+=" ${i}/${P}.tar.xz"
		SRC_URI+=" ${i}/${PN}-help-${PV}.tar.xz"
	done
	unset i
fi
unset DEV_URI

# Really required addons
# These are bundles that can't be removed for now due to huge patchsets.
# If you want them gone, patches are welcome.
ADDONS_SRC=(
	"collada? ( ${ADDONS_URI}/4b87018f7fff1d054939d19920b751a0-collada2gltf-master-cb1d97788a.tar.bz2 )"
	"java? ( ${ADDONS_URI}/17410483b5b5f267aa18b7e00b65e6e0-hsqldb_1_8_0.zip )"
	# no release for 8 years, should we package it?
	"libreoffice_extensions_wiki-publisher? ( ${ADDONS_URI}/a7983f859eafb2677d7ff386a023bc40-xsltml_2.1.2.zip )"
	# Does not build with 1.6 rhino at all
	"libreoffice_extensions_scripting-javascript? ( ${ADDONS_URI}/798b2ffdc8bcfe7bca2cf92b62caf685-rhino1_5R5.zip )"
	# requirement of rhino
	"libreoffice_extensions_scripting-javascript? ( ${ADDONS_URI}/35c94d2df8893241173de1d16b6034c0-swingExSrc.zip )"
	# not packageable
	"odk? ( http://download.go-oo.org/extern/185d60944ea767075d27247c3162b3bc-unowinreg.dll )"
)
SRC_URI+=" ${ADDONS_SRC[*]}"

unset ADDONS_URI
unset ADDONS_SRC

# Extensions that need extra work:
LO_EXTS="nlpsolver scripting-beanshell scripting-javascript wiki-publisher"

IUSE="bluetooth +branding coinmp collada +cups dbus debug eds firebird gltf googledrive
gstreamer +gtk gtk3 jemalloc kde libressl mysql odk pdfimport postgres quickstarter test vlc
$(printf 'libreoffice_extensions_%s ' ${LO_EXTS})"

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
	app-crypt/gpgme[cxx]
	app-text/hunspell:=
	>=app-text/libabw-0.1.0
	>=app-text/libebook-0.1
	>=app-text/libetonyek-0.1
	app-text/libexttextcat
	app-text/liblangtag
	>=app-text/libmspub-0.1.0
	>=app-text/libmwaw-0.3.1
	>=app-text/libodfgen-0.1.0
	app-text/libstaroffice
	app-text/libwpd:0.10[tools]
	app-text/libwpg:0.3
	>=app-text/libwps-0.4
	app-text/mythes
	>=dev-cpp/clucene-2.3.3.4-r2
	=dev-cpp/libcmis-0.5*
	dev-db/unixODBC
	dev-lang/perl
	dev-libs/boost:=
	dev-libs/expat
	dev-libs/hyphen
	dev-libs/icu:=
	dev-libs/libassuan
	dev-libs/libgpg-error
	=dev-libs/liborcus-0.12*
	dev-libs/librevenge
	dev-libs/nspr
	dev-libs/nss
	!libressl? ( >=dev-libs/openssl-1.0.0d:0 )
	libressl? ( dev-libs/libressl )
	>=dev-libs/redland-1.0.16
	>=dev-libs/xmlsec-1.2.24[nss]
	media-gfx/graphite2
	media-libs/fontconfig
	media-libs/freetype:2
	>=media-libs/harfbuzz-0.9.42:=[graphite,icu]
	media-libs/lcms:2
	>=media-libs/libcdr-0.1.0
	>=media-libs/libepoxy-1.3.1[X]
	>=media-libs/libfreehand-0.1.0
	media-libs/libpagemaker
	>=media-libs/libpng-1.4:0=
	>=media-libs/libvisio-0.1.0
	media-libs/libzmf
	net-libs/neon
	net-misc/curl
	net-nds/openldap
	sci-mathematics/lpsolve
	virtual/glu
	virtual/jpeg:0
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	bluetooth? ( net-wireless/bluez )
	coinmp? ( sci-libs/coinor-mp )
	collada? ( media-libs/opencollada )
	cups? ( net-print/cups )
	dbus? ( dev-libs/dbus-glib )
	eds? (
		dev-libs/glib:2
		gnome-base/dconf
		gnome-extra/evolution-data-server
	)
	firebird? ( >=dev-db/firebird-3.0.2.32703.0-r1 )
	gltf? ( >=media-libs/libgltf-0.1.0 )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gtk? (
		x11-libs/gdk-pixbuf
		>=x11-libs/gtk+-2.24:2
	)
	gtk3? (
		dev-libs/glib:2
		dev-libs/gobject-introspection
		gnome-base/dconf
		x11-libs/gtk+:3
	)
	jemalloc? ( dev-libs/jemalloc )
	kde? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		kde-frameworks/kdelibs
	)
	libreoffice_extensions_scripting-beanshell? ( dev-java/bsh )
	libreoffice_extensions_scripting-javascript? ( dev-java/rhino:1.6 )
	mysql? ( dev-db/mysql-connector-c++ )
	pdfimport? ( app-text/poppler:=[cxx] )
	postgres? ( >=dev-db/postgresql-9.0:*[kerberos] )
"

RDEPEND="${COMMON_DEPEND}
	!app-office/libreoffice-bin
	!app-office/libreoffice-bin-debug
	!app-office/openoffice
	media-fonts/dejavu
	media-fonts/liberation-fonts
	media-fonts/libertine
	|| ( x11-misc/xdg-utils kde-plasma/kde-cli-tools )
	java? ( >=virtual/jre-1.6 )
	kde? ( kde-frameworks/oxygen-icons:* )
	vlc? ( media-video/vlc )
"

if [[ ${PV} != *9999* ]]; then
	PDEPEND="=app-office/libreoffice-l10n-$(get_version_component_range 1-2)*"
else
	# Translations are not reliable on live ebuilds
	# rather force people to use english only.
	PDEPEND="!app-office/libreoffice-l10n"
fi

# FIXME: cppunit should be moved to test conditional
#        after everything upstream is under gbuild
#        as dmake execute tests right away
DEPEND="${COMMON_DEPEND}
	!<sys-devel/make-3.82
	>=dev-libs/libatomic_ops-7.2d
	>=dev-libs/libxml2-2.7.8
	dev-libs/libxslt
	dev-perl/Archive-Zip
	>=dev-util/cppunit-1.14.0
	>=dev-util/gperf-3
	dev-util/intltool
	>=dev-util/mdds-1.2.2:1=
	media-libs/glm
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	sys-devel/ucpp
	sys-libs/zlib
	virtual/pkgconfig
	x11-libs/libXt
	x11-libs/libXtst
	x11-proto/randrproto
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	java? (
		dev-java/ant-core
		>=virtual/jdk-1.6
	)
	odk? ( >=app-doc/doxygen-1.8.4 )
	test? (
		dev-util/cppunit
		media-fonts/dejavu
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	bluetooth? ( dbus )
	collada? ( gltf )
	libreoffice_extensions_nlpsolver? ( java )
	libreoffice_extensions_scripting-beanshell? ( java )
	libreoffice_extensions_scripting-javascript? ( java )
	libreoffice_extensions_wiki-publisher? ( java )
"

PATCHES=(
	# not upstreamable stuff
	"${FILESDIR}/${PN}-5.4-system-pyuno.patch"
	"${FILESDIR}/${PN}-5.3.4.2-kioclient5.patch"

	# TODO: upstream
	"${FILESDIR}/${PN}-5.2.5.1-glibc-2.24.patch"
	"${FILESDIR}/${PN}-5.4.4.2-gtk3-no-gtk-build.patch" # bug 641812
	"${FILESDIR}/${PN}-5.4.4.2-poppler-0.62.patch" # bug 642602

	"${FILESDIR}/${P}-pyuno-crash.patch" # 5.4.5 branch commit after release
)

pkg_pretend() {
	use java || \
		ewarn "If you plan to use Base application you should enable java or you will get various crashes."

	if has_version "<app-office/libreoffice-5.3.0[firebird]"; then
		ewarn "Firebird has been upgraded to version 3.0.0. It is unable to read back Firebird 2.5 data,"
		ewarn "so embedded firebird odb files created in LibreOffice pre-5.3 cannot be opened with LibreOffice 5.3."
		ewarn "See also: https://wiki.documentfoundation.org/ReleaseNotes/5.3#Base"
	fi

	if [[ ${MERGE_TYPE} != binary ]]; then

		CHECKREQS_MEMORY="512M"
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			CHECKREQS_DISK_BUILD="22G"
		else
			CHECKREQS_DISK_BUILD="6G"
		fi
		check-reqs_pkg_pretend
	fi
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	python-single-r1_pkg_setup
	xdg_environment_reset

	if [[ ${MERGE_TYPE} != binary ]]; then
		CHECKREQS_MEMORY="512M"
		if is-flagq "-g*" && ! is-flagq "-g*0" ; then
			CHECKREQS_DISK_BUILD="22G"
		else
			CHECKREQS_DISK_BUILD="6G"
		fi
		check-reqs_pkg_setup
	fi
}

src_unpack() {
	[[ -n ${PATCHSET} ]] && unpack ${PATCHSET}
	use branding && unpack "${BRANDING}"

	if [[ ${PV} != *9999* ]]; then
		unpack "${P}.tar.xz"
		unpack "${PN}-help-${PV}.tar.xz"
	else
		local base_uri branch mypv
		base_uri="https://anongit.freedesktop.org/git"
		branch="master"
		mypv=${PV/.9999}
		[[ ${mypv} != ${PV} ]] && branch="${PN}-${mypv/./-}"
		git-r3_fetch "${base_uri}/${PN}/core" "refs/heads/${branch}"
		git-r3_checkout "${base_uri}/${PN}/core"

		git-r3_fetch "${base_uri}/${PN}/help" "refs/heads/master"
		git-r3_checkout "${base_uri}/${PN}/help" "helpcontent2" # doesn't match on help
	fi
}

src_prepare() {
	[[ -n ${PATCHSET} ]] && eapply "${WORKDIR}/${PATCHSET/.tar.xz/}"
	default

	AT_M4DIR="m4" eautoreconf
	# hack in the autogen.sh
	touch autogen.lastrun

	# system pyuno mess
	sed -i \
		-e "s:%eprefix%:${EPREFIX}:g" \
		-e "s:%libdir%:$(get_libdir):g" \
		pyuno/source/module/uno.py \
		pyuno/source/officehelper.py || die
	# sed in the tests
	sed -i \
		-e "s#all : build unitcheck#all : build#g" \
		solenv/gbuild/Module.mk || die
	sed -i \
		-e "s#check: dev-install subsequentcheck#check: unitcheck slowcheck dev-install subsequentcheck#g" \
		-e "s#Makefile.gbuild all slowcheck#Makefile.gbuild all#g" \
		Makefile.in || die

	sed -i \
		-e "s,/usr/share/bash-completion/completions,$(get_bashcompdir)," \
		-e "s,\$INSTALLDIRNAME.sh,${PN}," \
		bin/distro-install-desktop-integration || die

	if use branding; then
		# hack...
		mv -v "${WORKDIR}/branding-intro.png" "${S}/icon-themes/galaxy/brand/intro.png" || die
	fi

	# Don't list pdfimport support in desktop when built with none, bug # 605464
	if ! use pdfimport; then
		sed -i \
			-e ":MimeType: s:application/pdf;::" \
			-e ":Keywords: s:pdf;::" \
			sysui/desktop/menus/draw.desktop || die
	fi
}

src_configure() {
	# Set up Google API keys, see https://www.chromium.org/developers/how-tos/api-keys
	# Note: these are for Gentoo use ONLY. For your own distribution, please get
	# your own set of keys. Feel free to contact chromium@gentoo.org for more info.
	local google_default_client_id="329227923882.apps.googleusercontent.com"
	local google_default_client_secret="vgKG0NNv7GoDpbtoFNLxCUXu"

	# optimization flags
	export GMAKE_OPTIONS="${MAKEOPTS}"
	# System python enablement:
	export PYTHON_CFLAGS=$(python_get_CFLAGS)
	export PYTHON_LIBS=$(python_get_LIBS)

	if use collada; then
		export OPENCOLLADA_CFLAGS="-I/usr/include/opencollada/COLLADABaseUtils -I/usr/include/opencollada/COLLADAFramework -I/usr/include/opencollada/COLLADASaxFrameworkLoader -I/usr/include/opencollada/GeneratedSaxParser"
		export OPENCOLLADA_LIBS="-L /usr/$(get_libdir)/opencollada -lOpenCOLLADABaseUtils -lOpenCOLLADAFramework -lOpenCOLLADASaxFrameworkLoader -lGeneratedSaxParser"
	fi

	if use kde; then
		# bug 544108, bug 599076
		export QMAKEQT4="$(qt4_get_bindir)/qmake"
		export MOCQT4="$(qt4_get_bindir)/moc"
	fi

	# system headers/libs/...: enforce using system packages
	# --disable-breakpad: requires not-yet-in-tree dev-utils/breakpad
	# --enable-cairo: ensure that cairo is always required
	# --enable-*-link: link to the library rather than just dlopen on runtime
	# --enable-release-build: build the libreoffice as release
	# --disable-fetch-external: prevent dowloading during compile phase
	# --enable-extension-integration: enable any extension integration support
	# --without-{fonts,myspell-dicts,ppsd}: prevent install of sys pkgs
	# --disable-report-builder: too much java packages pulled in without pkgs
	# --without-system-sane: just sane.h header that is used for scan in writer,
	#   not linked or anything else, worthless to depend on
	# --disable-pdfium: not yet packaged
	local myeconfargs=(
		--with-system-dicts
		--with-system-epoxy
		--with-system-headers
		--with-system-jars
		--with-system-libs
		--enable-cairo-canvas
		--enable-largefile
		--enable-mergelibs
		--enable-neon
		--enable-python=system
		--enable-randr
		--enable-release-build
		--disable-breakpad
		--disable-ccache
		--disable-dependency-tracking
		--disable-epm
		--disable-fetch-external
		--disable-gstreamer-0-10
		--disable-online-update
		--disable-pdfium
		--disable-report-builder
		--with-alloc=$(use jemalloc && echo "jemalloc" || echo "system")
		--with-build-version="Gentoo official package"
		--enable-extension-integration
		--with-external-dict-dir="${EPREFIX}/usr/share/myspell"
		--with-external-hyph-dir="${EPREFIX}/usr/share/myspell"
		--with-external-thes-dir="${EPREFIX}/usr/share/myspell"
		--with-external-tar="${DISTDIR}"
		--with-lang=""
		--with-parallelism=$(makeopts_jobs)
		--with-system-ucpp
		--with-vendor="Gentoo Foundation"
		--with-x
		--without-fonts
		--without-myspell-dicts
		--without-help
		--with-helppack-integration
		--with-system-gpgmepp
		--without-system-sane
		$(use_enable bluetooth sdremote-bluetooth)
		$(use_enable coinmp)
		$(use_enable collada)
		$(use_enable cups)
		$(use_enable debug)
		$(use_enable dbus)
		$(use_enable eds evolution2)
		$(use_enable firebird firebird-sdbc)
		$(use_enable gltf)
		$(use_enable gstreamer gstreamer-1-0)
		$(use_enable gtk)
		$(use_enable gtk3)
		$(use_enable kde kde4)
		$(use_enable mysql ext-mariadb-connector)
		$(use_enable odk)
		$(use_enable pdfimport)
		$(use_enable postgres postgresql-sdbc)
		$(use_enable quickstarter systray)
		$(use_enable vlc)
		$(use_with coinmp system-coinmp)
		$(use_with collada system-opencollada)
		$(use_with gltf system-libgltf)
		$(use_with googledrive gdrive-client-id ${google_default_client_id})
		$(use_with googledrive gdrive-client-secret ${google_default_client_secret})
		$(use_with java)
		$(use_with mysql system-mysql-cppconn)
		$(use_with odk doxygen)
	)

	if use eds || use gtk3; then
		myeconfargs+=( --enable-dconf --enable-gio )
	else
		myeconfargs+=( --disable-dconf --disable-gio )
	fi

	# libreoffice extensions handling
	for lo_xt in ${LO_EXTS}; do
		if [[ "${lo_xt}" == "scripting-beanshell" || "${lo_xt}" == "scripting-javascript" ]]; then
			myeconfargs+=( $(use_enable libreoffice_extensions_${lo_xt} ${lo_xt}) )
		else
			myeconfargs+=( $(use_enable libreoffice_extensions_${lo_xt} ext-${lo_xt}) )
		fi
	done

	if use java; then
		# hsqldb: system one is too new
		myeconfargs+=(
			--without-junit
			--without-system-hsqldb
			--with-ant-home="${ANT_HOME}"
			--with-jdk-home=$(java-config --jdk-home 2>/dev/null)
			--with-jvm-path="${EPREFIX}/usr/lib/"
		)

		use libreoffice_extensions_scripting-beanshell && \
			myeconfargs+=( --with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar) )

		use libreoffice_extensions_scripting-javascript && \
			myeconfargs+=( --with-rhino-jar=$(java-pkg_getjar rhino-1.6 js.jar) )
	fi

	econf "${myeconfargs[@]}"
}

src_compile() {
	# more and more LO stuff tries to use OpenGL, including tests during build
	# bug 501508, bug 540624, bug 545974 and probably more
	addpredict /dev/dri
	addpredict /dev/ati
	addpredict /dev/nvidiactl

	# hack for offlinehelp, this needs fixing upstream at some point
	# it is broken because we send --without-help
	# https://bugs.freedesktop.org/show_bug.cgi?id=46506
	(
		grep "^export" "${S}/config_host.mk" > "${T}/config_host.mk" || die
		source "${T}/config_host.mk" 2&> /dev/null

		local path="${WORKDIR}/helpcontent2/source/auxiliary/"
		mkdir -p "${path}" || die

		echo "perl \"${S}/helpcontent2/helpers/create_ilst.pl\" -dir=helpcontent2/source/media/helpimg > \"${path}/helpimg.ilst\""
		perl "${S}/helpcontent2/helpers/create_ilst.pl" \
			-dir=helpcontent2/source/media/helpimg \
			> "${path}/helpimg.ilst"
		[[ -s "${path}/helpimg.ilst" ]] || \
			ewarn "The help images list is empty, something is fishy, report a bug."
	)

	local target
	use test && target="build" || target="build-nocheck"

	# this is not a proper make script
	make ${target} || die
}

src_test() {
	make unitcheck || die
	make slowcheck || die
}

src_install() {
	# This is not Makefile so no buildserver
	make DESTDIR="${D}" distro-pack-install -o build -o check || die

	# bug 593514
	if use gtk3; then
		dosym libreoffice/program/liblibreofficekitgtk.so \
			/usr/$(get_libdir)/liblibreofficekitgtk.so
	fi

	# bash completion aliases
	bashcomp_alias \
		libreoffice \
		unopkg loimpress lobase localc lodraw lomath lowriter lofromtemplate loweb loffice

	if use branding; then
		insinto /usr/$(get_libdir)/${PN}/program
		newins "${WORKDIR}/branding-sofficerc" sofficerc
		dodir /etc/env.d
		echo "CONFIG_PROTECT=/usr/$(get_libdir)/${PN}/program/sofficerc" > "${ED}"etc/env.d/99${PN} || die
	fi

	# Hack for offlinehelp, this needs fixing upstream at some point.
	# It is broken because we send --without-help
	# https://bugs.freedesktop.org/show_bug.cgi?id=46506
	insinto /usr/$(get_libdir)/libreoffice/help
	doins xmlhelp/util/*.xsl

	# Remove desktop files to support old installs that can't parse mime
	rm -r "${ED}"usr/share/mimelnk/ || die

	pax-mark -m "${ED}"usr/$(get_libdir)/libreoffice/program/soffice.bin
	pax-mark -m "${ED}"usr/$(get_libdir)/libreoffice/program/unopkg.bin
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
