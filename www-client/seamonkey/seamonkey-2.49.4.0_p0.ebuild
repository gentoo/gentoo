# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
WANT_AUTOCONF="2.1"

# This list can be updated with scripts/get_langs.sh from the mozilla overlay
# note - could not roll langpacks for: ca fi
#MOZ_LANGS=(ca cs de en-GB es-AR es-ES fi fr gl hu it ja lt nb-NO nl pl pt-PT
#	    ru sk sv-SE tr uk zh-CN zh-TW)
MOZ_LANGS=(cs de en-GB es-AR es-ES fr hu it ja lt nl pl pt-PT
	    ru sk sv-SE zh-CN zh-TW)

MOZ_PV="${PV/_pre*}"
MOZ_PV="${MOZ_PV/_alpha/a}"
MOZ_PV="${MOZ_PV/_beta/b}"
MOZ_PV="${MOZ_PV/_rc/rc}"
MOZ_PV="${MOZ_PV/_p[0-9]}"
MOZ_P="${P}"
MY_MOZ_P="${PN}-${MOZ_PV}"

if [[ ${PV} == *_pre* ]] ; then
# the following are for upstream build candidates
	MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/candidates/${MOZ_PV}-candidates/build${PV##*_pre}"
	MOZ_LANGPACK_PREFIX="linux-i686/xpi/"
	SRC_URI+=" ${MOZ_HTTP_URI}/source/${MY_MOZ_P}.source.tar.xz -> ${P}.source.tar.xz"
	S="${WORKDIR}/${MY_MOZ_P}"
	# And the langpack stuff stays at eclass defaults
# the following is for self-rolled releases
	#MOZ_HTTP_URI="https://dev.gentoo.org/~axs/distfiles"
	#MOZ_LANGPACK_PREFIX="${MY_MOZ_P}."
	#MOZ_LANGPACK_SUFFIX=".langpack.xpi"
	#SRC_URI="${SRC_URI}
	#${MOZ_HTTP_URI}/${P}.source.tar.xz
	#"
elif [[ ${PV} == *_p[0-9] ]]; then
	# gentoo-unofficial release using thunderbird distfiles to build seamonkey instead
	TB_MAJOR=52
	SMPV="${PV%.[0-9].*}"
	MOZ_P="${PN}-${MOZ_PV}"
	MOZ_HTTP_URI="https://archive.mozilla.org/pub/thunderbird/releases/${MOZ_PV/${SMPV}/${TB_MAJOR}}"
# the following is for self-rolling localizations
	#MOZ_GENERATE_LANGPACKS=1
	#SRC_URI="${SRC_URI}
	#https://dev.gentoo.org/~axs/distfiles/${PN}-${SMPV}-l10n-sources-20170727.tar.xz"
# for this one use the localizations pre-rolled upstream for 2.49.1-candidate build 2
	MOZ_LANGPACK_PREFIX="../../../seamonkey/candidates/2.49.1-candidates/build2/linux-i686/xpi/"
	MOZ_LANGPACK_SUFFIX=".xpi"
	S="${WORKDIR}/thunderbird-${MOZ_PV/${SMPV}/${TB_MAJOR}}"
	CHATZILLA_VER="SEA2_48_RELBRANCH"
	INSPECTOR_VER="DOMI_2_0_17"
	SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/source/thunderbird-${MOZ_PV/${SMPV}/${TB_MAJOR}}.source.tar.xz
	https://hg.mozilla.org/chatzilla/archive/${CHATZILLA_VER}.tar.bz2 -> chatzilla-${CHATZILLA_VER}.tar.bz2
	https://hg.mozilla.org/dom-inspector/archive/${INSPECTOR_VER}.tar.bz2 -> dom-inspector-${INSPECTOR_VER}.tar.bz2
	"
else
	MOZ_HTTP_URI="https://archive.mozilla.org/pub/${PN}/releases/${MOZ_PV}"
	MOZ_LANGPACK_PREFIX="langpack/${MY_MOZ_P}."
	MOZ_LANGPACK_SUFFIX=".langpack.xpi"
	S="${WORKDIR}/${PN}-${MOZ_PV}"
	SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/source/${MY_MOZ_P}.source.tar.xz -> ${P}.source.tar.xz
	"
fi

MOZCONFIG_OPTIONAL_GTK3=1
MOZCONFIG_OPTIONAL_WIFI=1
inherit check-reqs flag-o-matic toolchain-funcs eutils mozconfig-v6.52 pax-utils xdg-utils autotools mozextension nsplugins mozlinguas-v2

PATCHFF="firefox-52.2-patches-03"
PATCH="${PN}-2.46-patches-01"

DESCRIPTION="Seamonkey Web Browser"
HOMEPAGE="http://www.seamonkey-project.org"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~ppc64 ~x86"

SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="+calendar +chatzilla +crypt +gmp-autoupdate +ipc jack minimal pulseaudio +roaming selinux test"

SRC_URI+="
	https://dev.gentoo.org/~anarchy/mozilla/patchsets/${PATCHFF}.tar.xz
	https://dev.gentoo.org/~axs/mozilla/patchsets/${PATCHFF}.tar.xz
	https://dev.gentoo.org/~polynomial-c/mozilla/patchsets/${PATCHFF}.tar.xz
	https://dev.gentoo.org/~axs/mozilla/patchsets/${PATCH}.tar.xz
	https://dev.gentoo.org/~polynomial-c/mozilla/patchsets/${PATCH}.tar.xz
"

ASM_DEPEND=">=dev-lang/yasm-1.1"

RDEPEND="
	>=dev-libs/nss-3.28.1
	>=dev-libs/nspr-4.13
	crypt? ( x11-plugins/enigmail )
	jack? ( virtual/jack )
"

DEPEND="
	${RDEPEND}
	!elibc_glibc? ( !elibc_uclibc? ( !elibc_musl? ( dev-libs/libexecinfo ) ) )
	amd64? ( ${ASM_DEPEND}
		virtual/opengl )
	x86? ( ${ASM_DEPEND}
		virtual/opengl )
"

BUILD_OBJ_DIR="${S}/seamonk"

# allow GMP_PLUGIN_LIST to be set in an eclass or
# overridden in the enviromnent (advanced hackers only)
if [[ -z $GMP_PLUGIN_LIST ]] ; then
	GMP_PLUGIN_LIST=( gmp-gmpopenh264 gmp-widevinecdm )
fi

pkg_setup() {
	if [[ ${PV} == *_pre* ]] ; then
		ewarn "You're using an unofficial release of ${PN}. Don't file any bug in"
		ewarn "Gentoo's Bugtracker against this package in case it breaks for you."
		ewarn "Those belong to upstream: https://bugzilla.mozilla.org"
	fi

	moz_pkgsetup
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	if use debug || use test ; then
		CHECKREQS_DISK_BUILD="8G"
	else
		CHECKREQS_DISK_BUILD="4G"
	fi
	check-reqs_pkg_setup
}

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack

	if [[ -n $TB_MAJOR ]]; then
		# move the irc and inspector code into the correct locations
		# when we are building from a thunderbird tarball
		mv "${WORKDIR}"/chatzilla-${CHATZILLA_VER} \
			"${S}"/mozilla/extensions/irc || die
		mv "${WORKDIR}"/dom-inspector-${INSPECTOR_VER} \
			"${S}"/mozilla/extensions/inspector || die
	fi
}

src_prepare() {
	# Apply our patches
	eapply "${WORKDIR}"/seamonkey

	# browser patches go here
	pushd "${S}"/mozilla &>/dev/null || die
	rm -f "${WORKDIR}"/firefox/1000_gentoo_install_dir.patch
	eapply "${WORKDIR}"/firefox
	popd &>/dev/null || die

	if grep -q '^sdkdir.*$(MOZ_APP_NAME)-devel' mozilla/config/baseconfig.mk ; then
		sed '/^sdkdir/s@-devel@@' \
			-i mozilla/config/baseconfig.mk || die
	else
		einfo "baseconfig.mk hackery no longer needed."
	fi

	# Shell scripts sometimes contain DOS line endings; bug 391889
	grep -rlZ --include="*.sh" $'\r$' . |
	while read -r -d $'\0' file ; do
		einfo edos2unix "${file}"
		edos2unix "${file}"
	done

	# force a version update that matches the minor and patch version of thunderbird
	if [[ -n ${TB_MAJOR} ]]; then
		echo ${MOZ_PV} >"${S}"/suite/config/version.txt
	fi

	# Allow user to apply any additional patches without modifing ebuild
	eapply_user

	local ms="${S}/mozilla"

	# Enable gnomebreakpad
	if use debug ; then
		sed -i -e "s:GNOME_DISABLE_CRASH_DIALOG=1:GNOME_DISABLE_CRASH_DIALOG=0:g" \
			"${ms}"/build/unix/run-mozilla.sh || die "sed failed!"
	fi

	# Ensure that are plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${ms}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${ms}"/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/suite/installer/Makefile.in || die
	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${ms}"/toolkit/mozapps/installer/packager.mk || die

	# Don't build libs-% locale files for chatzilla if we are not building chatzilla
	# (this is hard-coded in the build system at present rather than being based on configuration)
	use chatzilla || sed '/extensions\/irc\/locales libs-/s@^@#@' \
		-i "${S}"/suite/locales/Makefile.in || die

	eautoreconf old-configure.in
	cd "${S}"/mozilla || die
	eautoconf old-configure.in
	cd "${S}"/mozilla/js/src || die
	eautoconf old-configure.in
	cd "${S}"/mozilla/memory/jemalloc/src || die
	WANT_AUTOCONF= eautoconf
}

src_configure() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS="default"
	# Google API keys (see http://www.chromium.org/developers/how-tos/api-keys)
	# Note: These are for Gentoo Linux use ONLY. For your own distribution, please
	# get your own set of keys.
	_google_api_key=AIzaSyDEAOvatFo0eTgsV_ZlEzx0ObmepsMzfAc

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# enable JACK, bug 600002
	mozconfig_use_enable jack

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	if ! use chatzilla ; then
		MEXTENSIONS+=",-irc"
	fi
	if ! use roaming ; then
		MEXTENSIONS+=",-sroaming"
	fi

	# Setup api key for location services
	echo -n "${_google_api_key}" > "${S}"/google-api-key
	mozconfig_annotate '' --with-google-api-keyfile="${S}/google-api-key"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"

	# Other sm-specific settings
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}
	mozconfig_annotate '' --enable-safe-browsing
	mozconfig_use_enable calendar

	mozlinguas_mozconfig

	# Use an objdir to keep things organized.
	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig
	echo "mk_add_options XARGS=/usr/bin/xargs" >> "${S}"/.mozconfig

	# Finalize and report settings
	mozconfig_final

	# Work around breakage in makeopts with --no-print-directory
	MAKEOPTS="${MAKEOPTS/--no-print-directory/}"

	if [[ $(gcc-major-version) -lt 4 ]] ; then
		append-cxxflags -fno-stack-protector
	elif [[ $(gcc-major-version) -gt 4 || $(gcc-minor-version) -gt 3 ]] ; then
		if use amd64 || use x86 ; then
			append-flags -mno-avx
		fi
	fi

	# workaround for funky/broken upstream configure...
	SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake V=1 -f client.mk configure
}

src_compile() {
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL}" \
	emake V=1 -f client.mk

	mozlinguas_src_compile
}

src_install() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	DICTPATH="\"${EPREFIX}/usr/share/myspell\""

	local emid
	cd "${BUILD_OBJ_DIR}" || die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}/dist/bin/xpcshell"

	# Copy our preference before omnijar is created.
	sed "s|SEAMONKEY_PVR|${PVR}|" "${FILESDIR}"/all-gentoo-1.js > \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	# Set default path to search for dictionaries.
	echo "pref(\"spellchecker.dictionary_path\", ${DICTPATH});" \
		>> "${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	echo 'pref("extensions.autoDisableScopes", 3);' >> \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	local plugin
	if ! use gmp-autoupdate ; then
		for plugin in "${GMP_PLUGIN_LIST[@]}" ; do
			echo "pref(\"media.${plugin}.autoupdate\", false);" >> \
				"${S}/${BUILD_OBJ_DIR}/dist/bin/browser/defaults/preferences/all-gentoo.js" \
				|| dir
		done
	fi

	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL:-${EPREFIX%/}/bin/bash}" \
	emake DESTDIR="${D}" install
	cp "${FILESDIR}"/${PN}.desktop "${T}" || die

	sed 's|^\(MimeType=.*\)$|\1text/x-vcard;text/directory;application/mbox;message/rfc822;x-scheme-handler/mailto;|' \
		-i "${T}"/${PN}.desktop || die
	sed 's|^\(Categories=.*\)$|\1Email;|' -i "${T}"/${PN}.desktop \
		|| die

	# Install language packs
	mozlinguas_src_install

	# Add StartupNotify=true bug 290401
	if use startup-notification ; then
		echo "StartupNotify=true" >> "${T}"/${PN}.desktop || die
	fi

	# Install icon and .desktop for menu entry
	newicon "${S}"/suite/branding/nightly/content/icon64.png ${PN}.png
	domenu "${T}"/${PN}.desktop

	# Required in order to use plugins and even run seamonkey on hardened.
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/{seamonkey,seamonkey-bin,plugin-container}

	if use minimal ; then
		rm -rf "${ED}"/usr/include "${ED}${MOZILLA_FIVE_HOME}"/{idl,include,lib,sdk}
	fi

	if use crypt ; then
		emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' "${EROOT%/}"/usr/share/enigmail/install.rdf)
		if [[ -n ${emid} ]]; then
			dosym "${EPREFIX%/}"/usr/share/enigmail ${MOZILLA_FIVE_HOME}/extensions/${emid}
		else
			eerror "${EPREFIX%/}/usr/share/enigmail/install.rdf: No such file or directory"
			die "<EM:ID> tag for x11-plugins/enigmail could not be found!"
		fi
	fi

	if use chatzilla ; then
		local emid='{59c81df5-4b7a-477b-912d-4e0fdf64e5f2}'

		# remove the en_US-only xpi file so a version with all requested locales can be installed
		if [[ -e "${ED}"${MOZILLA_FIVE_HOME}/distribution/extensions/${emid}.xpi ]]; then
			rm -f "${ED}"${MOZILLA_FIVE_HOME}/distribution/extensions/${emid}.xpi || die
		fi

		# merge the extra locales into the main extension
		mozlinguas_xpistage_langpacks "${BUILD_OBJ_DIR}"/dist/xpi-stage/chatzilla

		# install the merged extension
		mkdir -p "${T}/${emid}" || die
		cp -RLp -t "${T}/${emid}" "${BUILD_OBJ_DIR}"/dist/xpi-stage/chatzilla/* || die
		insinto ${MOZILLA_FIVE_HOME}/distribution/extensions
		doins -r "${T}/${emid}"
	fi

	# Handle plugins dir through nsplugins.eclass
	share_plugins_dir

	# revdep-rebuild entry
	insinto /etc/revdep-rebuild
	echo "SEARCH_DIRS_MASK=${MOZILLA_FIVE_HOME}*" >> ${T}/11${PN}
	doins "${T}"/11${PN}
}

pkg_preinst() {
	MOZILLA_FIVE_HOME="${ROOT}/usr/$(get_libdir)/${PN}"

	if [ -d ${MOZILLA_FIVE_HOME}/plugins ] ; then
		rm ${MOZILLA_FIVE_HOME}/plugins -rf
	fi

	# Because PM's dont seem to properly merge a symlink replacing a directory
	if use crypt ; then
		local emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' "${EROOT%/}"/usr/share/enigmail/install.rdf)
		local emidpath="${EROOT%/}"${MOZILLA_FIVE_HOME}/extensions/${emid}
		if [[ -z ${emid} ]]; then
			eerror "${EROOT%/}/usr/share/enigmail/install.rdf: No such file or directory"
			die "Could not find enigmail on disk during pkg_preinst()"
		fi
		if [[ ! -h "${emidpath}" ]] && [[ -d "${emidpath}" ]]; then
			if ! rm -R --interactive=never "${emidpath}" ; then
				eerror "Could not remove enigmail directory from previous installation,"
				eerror "You must remove this by hand and rename the symbolic link yourself:"
				eerror
				eerror "\t cd ${EPREFIX%/}${MOZILLA_FIVE_HOME}/extensions"
				eerror "\t rm -Rf ${emid}"
				eerror "\t mv ${emid}.backup* ${emid}"
			fi
		fi
	fi
}

pkg_postinst() {
	MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"

	# Update mimedb for the new .desktop file
	xdg_desktop_database_update
	#gnome2_icon_cache_update

	if ! use gmp-autoupdate ; then
		elog "USE='-gmp-autoupdate' has disabled the following plugins from updating or"
		elog "installing into new profiles:"
		local plugin
		for plugin in "${GMP_PLUGIN_LIST[@]}"; do elog "\t ${plugin}" ; done
	fi

	if use chatzilla ; then
		elog "chatzilla is now an extension which can be en-/disabled and configured via"
		elog "the Add-on manager."
	fi
}
