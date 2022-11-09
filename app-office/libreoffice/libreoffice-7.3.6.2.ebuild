# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
PYTHON_REQ_USE="threads(+),xml(+)"

MY_PV="${PV/_alpha/.alpha}"
MY_PV="${MY_PV/_beta/.beta}"
# experimental ; release ; old
# Usually the tarballs are moved a lot so this should make everyone happy.
DEV_URI="
	https://dev-builds.libreoffice.org/pre-releases/src
	https://download.documentfoundation.org/libreoffice/src/${MY_PV:0:5}/
	https://downloadarchive.documentfoundation.org/libreoffice/old/${MY_PV}/src
"
ADDONS_URI="https://dev-www.libreoffice.org/src/"

BRANDING="${PN}-branding-gentoo-0.8.tar.xz"
PATCHSET="${PN}-7.3.5.2-patchset-01.tar.xz"

[[ ${MY_PV} == *9999* ]] && inherit git-r3
inherit autotools bash-completion-r1 check-reqs flag-o-matic java-pkg-opt-2 multiprocessing python-single-r1 qmake-utils toolchain-funcs xdg-utils

DESCRIPTION="A full office productivity suite"
HOMEPAGE="https://www.libreoffice.org"
SRC_URI="branding? ( https://dev.gentoo.org/~dilfridge/distfiles/${BRANDING} )"
[[ -n ${PATCHSET} ]] && SRC_URI+=" https://dev.gentoo.org/~xen0n/distfiles/app-office/libreoffice/${PATCHSET}"

# Split modules following git/tarballs; Core MUST be first!
# Help is used for the image generator
# Only release has the tarballs
if [[ ${MY_PV} != *9999* ]]; then
	for i in ${DEV_URI}; do
		SRC_URI+=" ${i}/${PN}-${MY_PV}.tar.xz"
		SRC_URI+=" ${i}/${PN}-help-${MY_PV}.tar.xz"
	done
	unset i
fi
unset DEV_URI

# Really required addons
# These are bundles that can't be removed for now due to huge patchsets.
# If you want them gone, patches are welcome.
ADDONS_SRC=(
	# broken against latest upstream release, too many patches on top:
	# https://github.com/tdf/libcmis/pull/43
	"${ADDONS_URI}/libcmis-0.5.2.tar.xz"
	# not packaged in Gentoo, https://www.netlib.org/fp/dtoa.c
	"${ADDONS_URI}/dtoa-20180411.tgz"
	# not packaged in Gentoo, https://skia.org/
	"${ADDONS_URI}/skia-m97-a7230803d64ae9d44f4e1282444801119a3ae967.tar.xz"
	"base? (
		${ADDONS_URI}/commons-logging-1.2-src.tar.gz
		${ADDONS_URI}/ba2930200c9f019c2d93a8c88c651a0f-flow-engine-0.9.4.zip
		${ADDONS_URI}/d8bd5eed178db6e2b18eeed243f85aa8-flute-1.1.6.zip
		${ADDONS_URI}/eeb2c7ddf0d302fba4bfc6e97eac9624-libbase-1.1.6.zip
		${ADDONS_URI}/3bdf40c0d199af31923e900d082ca2dd-libfonts-1.1.6.zip
		${ADDONS_URI}/3404ab6b1792ae5f16bbd603bd1e1d03-libformula-1.1.7.zip
		${ADDONS_URI}/db60e4fde8dd6d6807523deb71ee34dc-liblayout-0.2.10.zip
		${ADDONS_URI}/97b2d4dba862397f446b217e2b623e71-libloader-1.1.6.zip
		${ADDONS_URI}/8ce2fcd72becf06c41f7201d15373ed9-librepository-1.1.6.zip
		${ADDONS_URI}/f94d9870737518e3b597f9265f4e9803-libserializer-1.1.6.zip
		${ADDONS_URI}/ace6ab49184e329db254e454a010f56d-libxml-1.1.7.zip
		${ADDONS_URI}/39bb3fcea1514f1369fcfc87542390fd-sacjava-1.3.zip
	)"
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

IUSE="accessibility base bluetooth +branding clang coinmp +cups custom-cflags +dbus debug eds firebird
googledrive gstreamer +gtk kde ldap +mariadb odk pdfimport postgres test vulkan
$(printf 'libreoffice_extensions_%s ' ${LO_EXTS})"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	base? ( firebird java )
	bluetooth? ( dbus )
	gtk? ( dbus )
	libreoffice_extensions_nlpsolver? ( java )
	libreoffice_extensions_scripting-beanshell? ( java )
	libreoffice_extensions_scripting-javascript? ( java )
	libreoffice_extensions_wiki-publisher? ( java )
"

RESTRICT="!test? ( test )"

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"

[[ ${MY_PV} == *9999* ]] || \
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 x86 ~amd64-linux"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
	app-crypt/gpgme:=[cxx]
	app-text/hunspell:=
	>=app-text/libabw-0.1.0
	>=app-text/libebook-0.1
	app-text/libepubgen
	>=app-text/libetonyek-0.1
	app-text/libexttextcat
	app-text/liblangtag
	>=app-text/libmspub-0.1.0
	>=app-text/libmwaw-0.3.1
	>=app-text/libnumbertext-1.0.6
	>=app-text/libodfgen-0.1.0
	app-text/libqxp
	app-text/libstaroffice
	app-text/libwpd:0.10[tools]
	app-text/libwpg:0.3
	>=app-text/libwps-0.4
	app-text/mythes
	dev-cpp/abseil-cpp:=
	>=dev-cpp/clucene-2.3.3.4-r2
	>=dev-cpp/libcmis-0.5.2
	dev-db/unixODBC
	dev-lang/perl
	dev-libs/boost:=[nls]
	dev-libs/expat
	dev-libs/hyphen
	dev-libs/icu:=
	dev-libs/libassuan
	dev-libs/libgpg-error
	>=dev-libs/liborcus-0.17.2:0/0.17
	dev-libs/librevenge
	dev-libs/libxml2
	dev-libs/libxslt
	dev-libs/nspr
	dev-libs/nss
	>=dev-libs/redland-1.0.16
	>=dev-libs/xmlsec-1.2.28[nss]
	>=games-engines/box2d-2.4.1:0
	media-gfx/fontforge
	media-gfx/graphite2
	media-libs/fontconfig
	>=media-libs/freetype-2.11.0-r1:2
	>=media-libs/harfbuzz-0.9.42:=[graphite,icu]
	media-libs/lcms:2
	>=media-libs/libcdr-0.1.0
	>=media-libs/libepoxy-1.3.1[X]
	>=media-libs/libfreehand-0.1.0
	media-libs/libjpeg-turbo:=
	media-libs/libpagemaker
	>=media-libs/libpng-1.4:0=
	>=media-libs/libvisio-0.1.0
	media-libs/libzmf
	media-libs/openjpeg:=
	media-libs/zxing-cpp:=
	>=net-libs/neon-0.31.1:=
	net-misc/curl
	sci-mathematics/lpsolve
	sys-libs/zlib
	virtual/opengl
	x11-libs/cairo[X]
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	accessibility? (
		$(python_gen_cond_dep 'dev-python/lxml[${PYTHON_USEDEP}]')
	)
	bluetooth? (
		dev-libs/glib:2
		net-wireless/bluez
	)
	coinmp? ( sci-libs/coinor-mp )
	cups? ( net-print/cups )
	dbus? ( sys-apps/dbus[X] )
	eds? (
		dev-libs/glib:2
		gnome-base/dconf
		gnome-extra/evolution-data-server
	)
	firebird? ( >=dev-db/firebird-3.0.2.32703.0-r1[server] )
	gstreamer? (
		media-libs/gstreamer:1.0
		media-libs/gst-plugins-base:1.0
	)
	gtk? (
		dev-libs/glib:2
		dev-libs/gobject-introspection
		gnome-base/dconf
		media-libs/mesa[egl(+)]
		x11-libs/gtk+:3[X]
		x11-libs/pango
	)
	kde? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		dev-qt/qtx11extras:5
		kde-frameworks/kconfig:5
		kde-frameworks/kcoreaddons:5
		kde-frameworks/ki18n:5
		kde-frameworks/kio:5
		kde-frameworks/kwindowsystem:5
	)
	ldap? ( net-nds/openldap:= )
	libreoffice_extensions_scripting-beanshell? ( dev-java/bsh )
	libreoffice_extensions_scripting-javascript? ( >=dev-java/rhino-1.7.14:1.6 )
	mariadb? ( dev-db/mariadb-connector-c:= )
	!mariadb? ( dev-db/mysql-connector-c:= )
	pdfimport? ( >=app-text/poppler-22.06:=[cxx] )
	postgres? ( >=dev-db/postgresql-9.0:*[kerberos] )
"
# FIXME: cppunit should be moved to test conditional
#        after everything upstream is under gbuild
#        as dmake execute tests right away
#        tests apparently also need google-carlito-fonts (not packaged)
DEPEND="${COMMON_DEPEND}
	>=dev-libs/libatomic_ops-7.2d
	dev-perl/Archive-Zip
	>=dev-util/cppunit-1.14.0
	>=dev-util/gperf-3.1
	dev-util/mdds:1/2.0
	media-libs/glm
	sys-devel/ucpp
	x11-base/xorg-proto
	x11-libs/libXt
	x11-libs/libXtst
	java? (
		dev-java/ant-core
		>=virtual/jdk-11
	)
	test? (
		app-crypt/gnupg
		dev-util/cppunit
		media-fonts/dejavu
		media-fonts/liberation-fonts
	)
"
RDEPEND="${COMMON_DEPEND}
	acct-group/libreoffice
	acct-user/libreoffice
	!app-office/libreoffice-bin
	!app-office/libreoffice-bin-debug
	media-fonts/liberation-fonts
	|| ( x11-misc/xdg-utils kde-plasma/kde-cli-tools )
	java? ( >=virtual/jre-11 )
	kde? ( kde-frameworks/breeze-icons:* )
"
BDEPEND="
	dev-util/intltool
	sys-apps/which
	sys-devel/bison
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	clang? (
		|| (
			(	sys-devel/clang:15
				sys-devel/llvm:15
				=sys-devel/lld-15*	)
			(	sys-devel/clang:14
				sys-devel/llvm:14
				=sys-devel/lld-14*	)
			(	sys-devel/clang:13
				sys-devel/llvm:13
				=sys-devel/lld-13*	)
		)
	)
	odk? ( >=app-doc/doxygen-1.8.4 )
"
if [[ ${MY_PV} != *9999* ]] && [[ ${PV} != *_* ]]; then
	PDEPEND="=app-office/libreoffice-l10n-$(ver_cut 1-2)*"
else
	# Translations are not reliable on live ebuilds
	# rather force people to use english only.
	PDEPEND="!app-office/libreoffice-l10n"
fi

PATCHES=(
	"${WORKDIR}"/${PATCHSET/.tar.xz/}

	# not upstreamable stuff
	"${FILESDIR}/${PN}-5.3.4.2-kioclient5.patch"
	"${FILESDIR}/${PN}-6.1-nomancompress.patch"
	"${FILESDIR}/${PN}-7.2.0.4-qt5detect.patch"

	# 7.4 branch
	"${FILESDIR}/${PN}-7.3.5.2-gpgme-1.18.0.patch"

	# pending upstream
	"${FILESDIR}/${PN}-7.3.5.2-poppler-22.09.0.patch"
)

S="${WORKDIR}/${PN}-${MY_PV}"

_check_reqs() {
	CHECKREQS_MEMORY="512M"
	if is-flagq "-g*" && ! is-flagq "-g*0" ; then
		CHECKREQS_DISK_BUILD="22G"
	else
		CHECKREQS_DISK_BUILD="6G"
	fi
	check-reqs_$1
}

pkg_pretend() {
	use base ||
		ewarn "If you plan to use Base application you must enable USE base."
	use java ||
		ewarn "Without USE java, several wizards are not going to be available."

	[[ ${MERGE_TYPE} != binary ]] && _check_reqs pkg_pretend
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	python-single-r1_pkg_setup
	xdg_environment_reset

	[[ ${MERGE_TYPE} != binary ]] && _check_reqs pkg_setup
}

src_unpack() {
	default

	if [[ ${MY_PV} = *9999* ]]; then
		local base_uri branch mypv
		base_uri="https://anongit.freedesktop.org/git"
		branch="master"
		mypv=${MY_PV/.9999}
		[[ ${mypv} != ${MY_PV} ]] && branch="${PN}-${mypv/./-}"
		git-r3_fetch "${base_uri}/${PN}/core" "refs/heads/${branch}"
		git-r3_checkout "${base_uri}/${PN}/core"
		LOCOREGIT_VERSION=${EGIT_VERSION}

		git-r3_fetch "${base_uri}/${PN}/help" "refs/heads/master"
		git-r3_checkout "${base_uri}/${PN}/help" "helpcontent2" # doesn't match on help
	fi
}

src_prepare() {
	default

	# sandbox violations on many systems, we don't need it. Bug #646406
	sed -i \
		-e "/KF5_CONFIG/s/kf5-config/no/" \
		configure.ac || die "Failed to disable kf5-config"

	AT_M4DIR="m4" eautoreconf
	# hack in the autogen.sh
	touch autogen.lastrun

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
		mv -v "${WORKDIR}/branding-intro.png" "icon-themes/colibre/brand/intro.png" || die
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

	# Show flags set at the beginning
	einfo "Preset CFLAGS:    ${CFLAGS}"
	einfo "Preset LDFLAGS:   ${LDFLAGS}"

	if use clang ; then
		# Force clang
		einfo "Enforcing the use of clang due to USE=clang ..."
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib
		LDFLAGS+=" -fuse-ld=lld"
	else
		# Force gcc
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		AR=gcc-ar
		CC=${CHOST}-gcc
		CXX=${CHOST}-g++
		NM=gcc-nm
		RANLIB=gcc-ranlib

		# Apparently the Clang flags get used even for GCC builds sometimes.
		# bug #838115
		sed -i -e "s/-flto=thin/-flto/" solenv/gbuild/platform/com_GCC_defs.mk || die
	fi

	if use custom-cflags ; then
		elog "USE=custom-cflags has been selected. You are on your own to make sure that"
		elog "the build succeeds. Good luck!"
	else
		strip-flags
	fi

	export LO_CLANG_CC=${CC}
	export LO_CLANG_CXX=${CXX}

	# Show flags set at the end
	einfo "  Used CFLAGS:    ${CFLAGS}"
	einfo "  Used LDFLAGS:   ${LDFLAGS}"

	# Ensure we use correct toolchain
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	if use vulkan && ! use clang ; then
		ewarn "Building skia with gcc may lead to performance issues. Disable vulkan or enable clang."
	fi

	# optimization flags
	export GMAKE_OPTIONS="${MAKEOPTS}"
	# System python enablement:
	export PYTHON_CFLAGS=$(python_get_CFLAGS)
	export PYTHON_LIBS=$(python_get_LIBS)

	use kde && export QT5DIR="$(qt5_get_bindir)/.."

	local gentoo_buildid="Gentoo official package"
	if [[ -n ${LOCOREGIT_VERSION} ]]; then
		gentoo_buildid+=" (from git: ${LOCOREGIT_VERSION})"
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
		--enable-build-opensymbol
		--enable-cairo-canvas
		--enable-largefile
		--enable-mergelibs
		--enable-python=system
		--enable-randr
		--enable-release-build
		--disable-breakpad
		--disable-bundle-mariadb
		--disable-ccache
		--disable-epm
		--disable-fetch-external
		--disable-gtk3-kde5
		--disable-online-update
		--disable-openssl
		--disable-pdfium
		--disable-qt6
		--with-extra-buildid="${gentoo_buildid}"
		--enable-extension-integration
		--with-external-dict-dir="${EPREFIX}/usr/share/myspell"
		--with-external-hyph-dir="${EPREFIX}/usr/share/myspell"
		--with-external-thes-dir="${EPREFIX}/usr/share/myspell"
		--with-external-tar="${DISTDIR}"
		--with-lang=""
		--with-parallelism=$(makeopts_jobs)
		--with-system-abseil
		--with-system-openjpeg
		--with-system-ucpp
		--with-tls=nss
		--with-vendor="Gentoo Foundation"
		--with-webdav="neon"
		--with-x
		--without-fonts
		--without-myspell-dicts
		--with-help="html"
		--without-helppack-integration
		--with-system-gpgmepp
		--without-system-jfreereport
		--without-system-libcmis
		--without-system-sane
		$(use_enable base report-builder)
		$(use_enable bluetooth sdremote-bluetooth)
		$(use_enable coinmp)
		$(use_enable cups)
		$(use_enable dbus)
		$(use_enable debug)
		$(use_enable eds evolution2)
		$(use_enable firebird firebird-sdbc)
		$(use_enable gstreamer gstreamer-1-0)
		$(use_enable gtk gtk3)
		$(use_enable kde kf5)
		$(use_enable kde qt5)
		$(use_enable ldap)
		$(use_enable odk)
		$(use_enable pdfimport)
		$(use_enable postgres postgresql-sdbc)
		$(use_enable vulkan skia)
		$(use_with accessibility lxml)
		$(use_with coinmp system-coinmp)
		$(use_with googledrive gdrive-client-id ${google_default_client_id})
		$(use_with googledrive gdrive-client-secret ${google_default_client_secret})
		$(use_with java)
		$(use_with odk doxygen)
	)

	if use eds || use gtk; then
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
			--with-jdk-home="${JAVA_HOME}"
		)

		use libreoffice_extensions_scripting-beanshell && \
			myeconfargs+=( --with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar) )

		use libreoffice_extensions_scripting-javascript && \
			myeconfargs+=( --with-rhino-jar=$(java-pkg_getjar rhino-1.6 rhino.jar) )
	fi

	is-flagq "-flto*" && myeconfargs+=( --enable-lto )

	MARIADBCONFIG="$(type -p $(usex mariadb mariadb mysql)_config)" \
	econf "${myeconfargs[@]}"
}

src_compile() {
	# more and more LO stuff tries to use OpenGL, including tests during build
	# bug 501508, bug 540624, bug 545974 and probably more
	addpredict /dev/dri
	addpredict /dev/ati
	addpredict /dev/nvidiactl

	default
}

src_test() {
	emake unitcheck
	emake slowcheck
}

src_install() {
	emake DESTDIR="${D}" distro-pack-install -o build -o check

	# bug 593514
	if use gtk; then
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
		echo "CONFIG_PROTECT=/usr/$(get_libdir)/${PN}/program/sofficerc" > "${ED}"/etc/env.d/99${PN} || die
	fi

	# bug 703474
	insinto /usr/include
	doins -r include/LibreOfficeKit

	local lodir=/usr/$(get_libdir)/libreoffice
	# patching this would break tests
	cat <<-EOF > "${T}"/uno.py
import sys, os
sys.path.append('${EPREFIX}${lodir}/program')
os.putenv('URE_BOOTSTRAP', 'vnd.sun.star.pathname:${EPREFIX}${lodir}/program/fundamentalrc')
EOF
	sed -e "/^import sys/d" -e "/^import os/d" \
		-i "${D}"${lodir}/program/uno.py || die "cleanup dupl imports failed"
	cat "${D}"${lodir}/program/uno.py >> "${T}"/uno.py || die
	cp "${T}"/uno.py "${D}"${lodir}/program/uno.py || die

	# more system pyuno mess
	sed -e "/sOffice = \"\" # lets hope for the best/s:\"\":\"${EPREFIX}${lodir}/program\":" \
		-i "${D}"${lodir}/program/officehelper.py || die

	python_optimize "${D}"${lodir}/program
	# link python bridge in site-packages, bug 667802
	local py pyc loprogdir=/usr/$(get_libdir)/libreoffice/program
	for py in uno.py unohelper.py officehelper.py; do
		dosym -r ${loprogdir}/${py} $(python_get_sitedir)/${py}
		while IFS="" read -d $'\0' -r pyc; do
			pyc=${pyc//*\/}
			dosym -r ${loprogdir}/__pycache__/${pyc} $(python_get_sitedir)/__pycache__/${pyc}
		done < <(find "${D}"${lodir}/program -type f -name ${py/.py/*.pyc} -print0)
	done

	newinitd "${FILESDIR}/libreoffice.initd" libreoffice
	newconfd "${FILESDIR}/libreoffice.confd" libreoffice
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
