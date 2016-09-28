# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_REQUIRED="optional"
KDE_SCM="git"
CMAKE_REQUIRED="never"

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
PYTHON_REQ_USE="threads,xml"

# experimental ; release ; old
# Usually the tarballs are moved a lot so this should make
# everyone happy.
DEV_URI="
	http://dev-builds.libreoffice.org/pre-releases/src
	http://download.documentfoundation.org/libreoffice/src/${PV:0:5}/
	http://download.documentfoundation.org/libreoffice/old/${PV}/
"
ADDONS_URI="http://dev-www.libreoffice.org/src/"

BRANDING="${PN}-branding-gentoo-0.8.tar.xz"
# PATCHSET="${P}-patchset-01.tar.xz"

[[ ${PV} == *9999* ]] && SCM_ECLASS="git-r3"
inherit multiprocessing autotools bash-completion-r1 check-reqs eutils java-pkg-opt-2 kde4-base pax-utils python-single-r1 multilib toolchain-funcs flag-o-matic versionator xdg-utils ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="A full office productivity suite"
HOMEPAGE="http://www.libreoffice.org"
SRC_URI="branding? ( http://dev.gentoo.org/~dilfridge/distfiles/${BRANDING} )"
[[ -n ${PATCHSET} ]] && SRC_URI+=" http://dev.gentooexperimental.org/~scarabeus/${PATCHSET}"

# Split modules following git/tarballs
# Core MUST be first!
# Help is used for the image generator
MODULES="core help"
# Only release has the tarballs
if [[ ${PV} != *9999* ]]; then
	for i in ${DEV_URI}; do
		for mod in ${MODULES}; do
			if [[ ${mod} == core ]]; then
				SRC_URI+=" ${i}/${P}.tar.xz"
			else
				SRC_URI+=" ${i}/${PN}-${mod}-${PV}.tar.xz"
			fi
		done
		unset mod
	done
	unset i
fi
unset DEV_URI

# Really required addons
# These are bundles that can't be removed for now due to huge patchsets.
# If you want them gone, patches are welcome.
ADDONS_SRC=(
	"${ADDONS_URI}/0fb1bb06d60d7708abc4797008209bcc-xmlsec1-1.2.22.tar.gz" # modifies source code
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

IUSE="bluetooth +branding coinmp collada +cups dbus debug eds firebird gltf gnome googledrive
gstreamer +gtk gtk3 jemalloc kde libressl mysql odk pdfimport postgres quickstarter telepathy test vlc
$(printf 'libreoffice_extensions_%s ' ${LO_EXTS})"

LICENSE="|| ( LGPL-3 MPL-1.1 )"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"

COMMON_DEPEND="${PYTHON_DEPS}
	app-arch/unzip
	app-arch/zip
	app-text/hunspell
	>=app-text/libabw-0.1.0
	>=app-text/libebook-0.1
	>=app-text/libetonyek-0.1
	app-text/libexttextcat
	app-text/liblangtag
	>=app-text/libmspub-0.1.0
	>=app-text/libmwaw-0.3.1
	>=app-text/libodfgen-0.1.0
	app-text/libwpd:0.10[tools]
	app-text/libwpg:0.3
	>=app-text/libwps-0.4
	app-text/mythes
	>=dev-cpp/clucene-2.3.3.4-r2
	=dev-cpp/libcmis-0.5*
	dev-db/unixODBC
	dev-lang/perl
	>=dev-libs/boost-1.55:=
	dev-libs/expat
	dev-libs/hyphen
	dev-libs/icu:=
	>=dev-libs/liborcus-0.11.2
	dev-libs/librevenge
	dev-libs/nspr
	dev-libs/nss
	!libressl? ( >=dev-libs/openssl-1.0.0d:0 )
	libressl? ( dev-libs/libressl )
	>=dev-libs/redland-1.0.16
	media-gfx/graphite2
	media-libs/fontconfig
	media-libs/freetype:2
	>=media-libs/glew-1.10:=
	>=media-libs/harfbuzz-0.9.18:=[icu(+)]
	media-libs/lcms:2
	>=media-libs/libcdr-0.1.0
	>=media-libs/libfreehand-0.1.0
	media-libs/libpagemaker
	>=media-libs/libpng-1.4:0=
	>=media-libs/libvisio-0.1.0
	net-libs/neon
	net-misc/curl
	net-nds/openldap
	sci-mathematics/lpsolve
	virtual/jpeg:0
	x11-libs/cairo[X,-xlib-xcb]
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	virtual/glu
	virtual/opengl
	bluetooth? ( net-wireless/bluez )
	coinmp? ( sci-libs/coinor-mp )
	collada? ( >=media-libs/opencollada-1.2.2_p20150207 )
	cups? ( net-print/cups )
	dbus? ( dev-libs/dbus-glib )
	eds? (
		dev-libs/glib:2
		gnome-extra/evolution-data-server
	)
	firebird? ( >=dev-db/firebird-2.5 )
	gltf? ( media-libs/libgltf )
	gnome? ( gnome-base/dconf )
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
		>=x11-libs/gtk+-3.8:3
	)
	jemalloc? ( dev-libs/jemalloc )
	libreoffice_extensions_scripting-beanshell? ( dev-java/bsh )
	libreoffice_extensions_scripting-javascript? ( dev-java/rhino:1.6 )
	mysql? ( dev-db/mysql-connector-c++ )
	pdfimport? ( app-text/poppler:=[cxx] )
	postgres? ( >=dev-db/postgresql-9.0:*[kerberos] )
	telepathy? ( net-libs/telepathy-glib )
"

RDEPEND="${COMMON_DEPEND}
	!app-office/libreoffice-bin
	!app-office/libreoffice-bin-debug
	!app-office/openoffice
	media-fonts/liberation-fonts
	media-fonts/libertine
	media-fonts/urw-fonts
	java? ( >=virtual/jre-1.6 )
	kde? ( $(add_kdeapps_dep kioclient) )
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
	dev-util/cppunit
	>=dev-util/gperf-3
	dev-util/intltool
	>=dev-util/mdds-1.2.0:1=
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
	test? ( dev-util/cppunit )
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}
	bluetooth? ( dbus )
	collada? ( gltf )
	eds? ( gnome )
	gnome? ( gtk )
	telepathy? ( gtk )
	libreoffice_extensions_nlpsolver? ( java )
	libreoffice_extensions_scripting-beanshell? ( java )
	libreoffice_extensions_scripting-javascript? ( java )
	libreoffice_extensions_wiki-publisher? ( java )
"

PATCHES=(
	# not upstreamable stuff
	"${FILESDIR}/${PN}-5.3-system-pyuno.patch"
)

CHECKREQS_MEMORY="512M"

if [[ ${MERGE_TYPE} != binary ]] && is-flagq "-g*" && ! is-flagq "-g*0" ; then
	CHECKREQS_DISK_BUILD="22G"
elif [[ ${MERGE_TYPE} != binary ]] ; then
	CHECKREQS_DISK_BUILD="6G"
fi

pkg_pretend() {
	use java || \
		ewarn "If you plan to use lbase application you should enable java or you will get various crashes."

	if [[ ${MERGE_TYPE} != binary ]]; then
		check-reqs_pkg_pretend

		if ! $(tc-is-clang) && [[ $(gcc-major-version) -lt 4 ]] || {
				[[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -lt 7 ]]; } then
			eerror "Compilation with gcc older than 4.7 is not supported"
			die "Too old gcc found."
		fi
	fi

	# Ensure pg version but we have to be sure the pg is installed (first
	# install on clean system)
	if use postgres && has_version dev-db/postgresql; then
		 local pgslot=$(postgresql-config show)
		 if [[ ${pgslot//.} -lt 90 ]] ; then
			eerror "PostgreSQL slot must be set to 9.0 or higher."
			eerror "    postgresql-config set 9.0"
			die "PostgreSQL slot is not set to 9.0 or higher."
		 fi
	fi
}

pkg_setup() {
	java-pkg-opt-2_pkg_setup
	kde4-base_pkg_setup
	python-single-r1_pkg_setup
	xdg_environment_reset

	[[ ${MERGE_TYPE} != binary ]] && check-reqs_pkg_setup
}

src_unpack() {
	local mod

	[[ -n ${PATCHSET} ]] && unpack ${PATCHSET}
	use branding && unpack "${BRANDING}"

	if [[ ${PV} != *9999* ]]; then
		unpack "${P}.tar.xz"
		for mod in ${MODULES}; do
			[[ ${mod} == core ]] && continue
			unpack "${PN}-${mod}-${PV}.tar.xz"
		done
	else
		local base_uri branch checkout mypv
		base_uri="git://anongit.freedesktop.org"
		for mod in ${MODULES}; do
			branch="master"
			mypv=${PV/.9999}
			[[ ${mypv} != ${PV} ]] && branch="${PN}-${mypv/./-}"
			git-r3_fetch "${base_uri}/${PN}/${mod}" "refs/heads/${branch}"
			[[ ${mod} != core ]] && checkout="${S}/${mod}"
			[[ ${mod} == help ]] && checkout="helpcontent2" # doesn't match on help
			git-r3_checkout "${base_uri}/${PN}/${mod}" ${checkout}
		done
	fi
}

src_prepare() {
	[[ -n ${PATCHSET} ]] && eapply "${WORKDIR}/${PATCHSET/.tar.xz/}"
	eapply "${PATCHES[@]}"
	eapply_user

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

	if use branding; then
		# hack...
		mv -v "${WORKDIR}/branding-intro.png" "${S}/icon-themes/galaxy/brand/intro.png" || die
	fi
}

src_configure() {
	local java_opts
	local ext_opts

	# Set up Google API keys, see http://www.chromium.org/developers/how-tos/api-keys
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

	# libreoffice extensions handling
	for lo_xt in ${LO_EXTS}; do
		if [[ "${lo_xt}" == "scripting-beanshell" || "${lo_xt}" == "scripting-javascript" ]]; then
			ext_opts+=" $(use_enable libreoffice_extensions_${lo_xt} ${lo_xt})"
		else
			ext_opts+=" $(use_enable libreoffice_extensions_${lo_xt} ext-${lo_xt})"
		fi
	done

	if use java; then
		# hsqldb: system one is too new
		java_opts="
			--without-junit
			--without-system-hsqldb
			--with-ant-home="${ANT_HOME}"
			--with-jdk-home=$(java-config --jdk-home 2>/dev/null)
			--with-jvm-path="${EPREFIX}/usr/lib/"
		"

		use libreoffice_extensions_scripting-beanshell && \
			java_opts+=" --with-beanshell-jar=$(java-pkg_getjar bsh bsh.jar)"

		use libreoffice_extensions_scripting-javascript && \
			java_opts+=" --with-rhino-jar=$(java-pkg_getjar rhino-1.6 js.jar)"
	fi

	# system headers/libs/...: enforce using system packages
	# --disable-breakpad: requires not-yet-in-tree dev-utils/breakpad
	# --enable-cairo: ensure that cairo is always required
	# --enable-graphite: disabling causes build breakages
	# --enable-*-link: link to the library rather than just dlopen on runtime
	# --enable-release-build: build the libreoffice as release
	# --disable-fetch-external: prevent dowloading during compile phase
	# --enable-extension-integration: enable any extension integration support
	# --without-{fonts,myspell-dicts,ppsd}: prevent install of sys pkgs
	# --disable-report-builder: too much java packages pulled in without pkgs
	# --without-system-sane: just sane.h header that is used for scan in writer,
	#   not linked or anything else, worthless to depend on
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/" \
		--with-system-dicts \
		--with-system-headers \
		--with-system-jars \
		--with-system-libs \
		--enable-cairo-canvas \
		--enable-graphite \
		--enable-largefile \
		--enable-mergelibs \
		--enable-neon \
		--enable-python=system \
		--enable-randr \
		--enable-release-build \
		--disable-breakpad \
		--disable-ccache \
		--disable-dependency-tracking \
		--disable-epm \
		--disable-fetch-external \
		--disable-gstreamer-0-10 \
		--disable-online-update \
		--disable-report-builder \
		--with-alloc=$(use jemalloc && echo "jemalloc" || echo "system") \
		--with-build-version="Gentoo official package" \
		--enable-extension-integration \
		--with-external-dict-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-hyph-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-thes-dir="${EPREFIX}/usr/share/myspell" \
		--with-external-tar="${DISTDIR}" \
		--with-lang="" \
		--with-parallelism=$(makeopts_jobs) \
		--with-system-ucpp \
		--with-vendor="Gentoo Foundation" \
		--with-x \
		--without-fonts \
		--without-myspell-dicts \
		--without-help \
		--with-helppack-integration \
		--without-system-sane \
		$(use_enable bluetooth sdremote-bluetooth) \
		$(use_enable coinmp) \
		$(use_enable collada) \
		$(use_enable cups) \
		$(use_enable debug) \
		$(use_enable dbus) \
		$(use_enable eds evolution2) \
		$(use_enable firebird firebird-sdbc) \
		$(use_enable gltf) \
		$(use_enable gnome gio) \
		$(use_enable gnome dconf) \
		$(use_enable gstreamer gstreamer-1-0) \
		$(use_enable gtk) \
		$(use_enable gtk3) \
		$(use_enable kde kde4) \
		$(use_enable mysql ext-mariadb-connector) \
		$(use_enable odk) \
		$(use_enable pdfimport) \
		$(use_enable postgres postgresql-sdbc) \
		$(use_enable quickstarter systray) \
		$(use_enable telepathy) \
		$(use_enable vlc) \
		$(use_with coinmp system-coinmp) \
		$(use_with collada system-opencollada) \
		$(use_with gltf system-libgltf) \
		$(use_with googledrive gdrive-client-id ${google_default_client_id}) \
		$(use_with googledrive gdrive-client-secret ${google_default_client_secret}) \
		$(use_with java) \
		$(use_with mysql system-mysql-cppconn) \
		$(use_with odk doxygen) \
		${java_opts} \
		${ext_opts}
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

		echo "perl \"${S}/helpcontent2/helpers/create_ilst.pl\" -dir=icon-themes/galaxy/res/helpimg > \"${path}/helpimg.ilst\""
		perl "${S}/helpcontent2/helpers/create_ilst.pl" \
			-dir=icon-themes/galaxy/res/helpimg \
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

	# Fix bash completion placement
	newbashcomp "${ED}"usr/share/bash-completion/completions/libreoffice.sh ${PN}
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
	# Cache updates - all handled by kde eclass for all environments
	kde4-base_pkg_preinst
}

pkg_postinst() {
	kde4-base_pkg_postinst
}

pkg_postrm() {
	kde4-base_pkg_postrm
}
