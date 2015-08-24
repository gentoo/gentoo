# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
WANT_AUTOCONF="2.1"
MOZ_ESR=""
MOZ_LIGHTNING_VER="4.0.2"
MOZ_LIGHTNING_GDATA_VER="1.9"

# This list can be updated using scripts/get_langs.sh from the mozilla overlay
MOZ_LANGS=(ar ast be bg bn-BD br ca cs cy da de el en en-GB en-US es-AR
es-ES et eu fi fr fy-NL ga-IE gd gl he hr hsb hu hy-AM id is it ja ko lt
nb-NO nl nn-NO pa-IN pl pt-BR pt-PT rm ro ru si sk sl sq sr sv-SE ta-LK tr
uk vi zh-CN zh-TW )

# Convert the ebuild version to the upstream mozilla version, used by mozlinguas
MOZ_PV="${PV/_beta/b}"
# ESR releases have slightly version numbers
if [[ ${MOZ_ESR} == 1 ]]; then
	MOZ_PV="${MOZ_PV}esr"
fi
MOZ_P="${PN}-${MOZ_PV}"

# Enigmail version
EMVER="1.8.2"

# Patches
PATCH="thunderbird-38.0-patches-0.1"
PATCHFF="firefox-38.0-patches-0.3"

MOZ_HTTP_URI="http://ftp.mozilla.org/pub/${PN}/releases"

MOZCONFIG_OPTIONAL_JIT="enabled"
inherit flag-o-matic toolchain-funcs mozconfig-v6.38 makeedit multilib autotools pax-utils check-reqs nsplugins mozlinguas

DESCRIPTION="Thunderbird Mail Client"
HOMEPAGE="http://www.mozilla.com/en-US/thunderbird/"

KEYWORDS="~alpha ~amd64 ~arm ~ppc ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
SLOT="0"
LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
IUSE="bindist crypt hardened ldap lightning +minimal mozdom selinux"
RESTRICT="!bindist? ( bindist )"

PATCH_URIS=( https://dev.gentoo.org/~{anarchy,axs,polynomial-c}/mozilla/patchsets/{${PATCH},${PATCHFF}}.tar.xz )
SRC_URI="${SRC_URI}
	${MOZ_HTTP_URI}/${MOZ_PV}/source/${MOZ_P}.source.tar.bz2
	${MOZ_HTTP_URI/${PN}/calendar/lightning}/${MOZ_LIGHTNING_VER}/linux/lightning.xpi -> lightning-${MOZ_LIGHTNING_VER}.xpi
	lightning? ( https://dev.gentoo.org/~axs/distfiles/gdata-provider-${MOZ_LIGHTNING_GDATA_VER}.tar.xz )
	crypt? ( http://www.enigmail.net/download/source/enigmail-${EMVER}.tar.gz )
	${PATCH_URIS[@]}"

ASM_DEPEND=">=dev-lang/yasm-1.1"

CDEPEND="
	>=dev-libs/nss-3.19.2
	>=dev-libs/nspr-4.10.8
	!x11-plugins/enigmail
	crypt?  ( || (
		( >=app-crypt/gnupg-2.0
			|| (
				app-crypt/pinentry[gtk]
				app-crypt/pinentry[qt4]
			)
		)
		=app-crypt/gnupg-1.4*
	) )"

DEPEND="${CDEPEND}
	amd64? ( ${ASM_DEPEND}
		virtual/opengl )
	x86? ( ${ASM_DEPEND}
		virtual/opengl )"

RDEPEND="${CDEPEND}
	selinux? ( sec-policy/selinux-thunderbird )
"

if [[ ${PV} =~ beta ]]; then
	S="${WORKDIR}/comm-beta"
else
	S="${WORKDIR}/comm-esr${PV%%.*}"
fi

BUILD_OBJ_DIR="${S}/tbird"

pkg_setup() {
	moz_pkgsetup

	export MOZILLA_DIR="${S}/mozilla"

	if ! use bindist ; then
		elog "You are enabling official branding. You may not redistribute this build"
		elog "to any users on your network or the internet. Doing so puts yourself into"
		elog "a legal problem with Mozilla Foundation"
		elog "You can disable it by emerging ${PN} _with_ the bindist USE-flag"
		elog
	fi
}

pkg_pretend() {
	# Ensure we have enough disk space to compile
	CHECKREQS_DISK_BUILD="4G"
	check-reqs_pkg_setup

	if use jit && [[ -n ${PROFILE_IS_HARDENED} ]]; then
		ewarn "You are emerging this package on a hardened profile with USE=jit enabled."
		ewarn "This is horribly insecure as it disables all PAGEEXEC restrictions."
		ewarn "Please ensure you know what you are doing.  If you don't, please consider"
		ewarn "emerging the package with USE=-jit"
	fi
}

src_unpack() {
	unpack ${A}

	# Unpack language packs
	mozlinguas_src_unpack

	xpi_unpack lightning-${MOZ_LIGHTNING_VER}.xpi
	# this version of gdata-provider is a .tar.xz , no xpi needed
	#use lightning && xpi_unpack gdata-provider-${MOZ_LIGHTNING_GDATA_VER}.xpi
}

src_prepare() {
	# Apply our Thunderbird patchset
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/thunderbird"

	# Apply our patchset from firefox to thunderbird as well
	pushd "${S}"/mozilla &>/dev/null || die
	EPATCH_SUFFIX="patch" \
	EPATCH_FORCE="yes" \
	epatch "${WORKDIR}/firefox"
	popd &>/dev/null || die

	# Ensure that are plugins dir is enabled as default
	sed -i -e "s:/usr/lib/mozilla/plugins:/usr/lib/nsbrowser/plugins:" \
		"${S}"/mozilla/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 32bit!"
	sed -i -e "s:/usr/lib64/mozilla/plugins:/usr/lib64/nsbrowser/plugins:" \
		"${S}"/mozilla/xpcom/io/nsAppFileLocationProvider.cpp || die "sed failed to replace plugin path for 64bit!"

	# Don't exit with error when some libs are missing which we have in
	# system.
	sed '/^MOZ_PKG_FATAL_WARNINGS/s@= 1@= 0@' \
		-i "${S}"/mail/installer/Makefile.in || die

	# Don't error out when there's no files to be removed:
	sed 's@\(xargs rm\)$@\1 -f@' \
		-i "${S}"/mozilla/toolkit/mozapps/installer/packager.mk || die

	# Shell scripts sometimes contain DOS line endings; bug 391889
	grep -rlZ --include="*.sh" $'\r$' . |
	while read -r -d $'\0' file ; do
		einfo edos2unix "${file}"
		edos2unix "${file}"
	done

	# Allow user to apply any additional patches without modifing ebuild
	epatch_user

	# Confirm the version of lightning being grabbed for langpacks is the same
	# as that used in thunderbird
	local THIS_MOZ_LIGHTNING_VER=$(python "${S}"/calendar/lightning/build/makeversion.py ${PV})
	if [[ ${MOZ_LIGHTNING_VER} != ${THIS_MOZ_LIGHTNING_VER} ]]; then
		eqawarn "The version of lightning used for localization differs from the version"
		eqawarn "in thunderbird.  Please update MOZ_LIGHTNING_VER in the ebuild from ${MOZ_LIGHTNING_VER}"
		eqawarn "to ${THIS_MOZ_LIGHTNING_VER}"
	fi

	eautoreconf
	# Ensure we run eautoreconf in mozilla to regenerate configure
	cd "${S}"/mozilla || die
	eautoconf
	cd "${S}"/mozilla/js/src || die
	eautoconf
}

src_configure() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	MEXTENSIONS="default"

	####################################
	#
	# mozconfig, CFLAGS and CXXFLAGS setup
	#
	####################################

	mozconfig_init
	mozconfig_config

	# It doesn't compile on alpha without this LDFLAGS
	use alpha && append-ldflags "-Wl,--no-relax"

	# Add full relro support for hardened
	use hardened && append-ldflags "-Wl,-z,relro,-z,now"

	mozconfig_annotate '' --enable-extensions="${MEXTENSIONS}"
	mozconfig_annotate '' --disable-mailnews
	mozconfig_annotate '' --enable-calendar

	# Other tb-specific settings
	mozconfig_annotate '' --with-default-mozilla-five-home=${MOZILLA_FIVE_HOME}
	mozconfig_annotate '' --with-user-appdir=.thunderbird

	mozconfig_use_enable ldap

	mozlinguas_mozconfig

	# Bug #72667
	if use mozdom; then
		MEXTENSIONS="${MEXTENSIONS},inspector"
	fi

	# Use an objdir to keep things organized.
	echo "mk_add_options MOZ_OBJDIR=${BUILD_OBJ_DIR}" >> "${S}"/.mozconfig

	# Finalize and report settings
	mozconfig_final

	####################################
	#
	#  Configure and build
	#
	####################################

	# Disable no-print-directory
	MAKEOPTS=${MAKEOPTS/--no-print-directory/}

	if [[ $(gcc-major-version) -lt 4 ]]; then
		append-cxxflags -fno-stack-protector
	fi

	if use crypt; then
		pushd "${WORKDIR}"/enigmail &>/dev/null ||die
		econf
		popd &>/dev/null ||die
	fi
}

src_compile() {
	mkdir -p "${BUILD_OBJ_DIR}" && cd "${BUILD_OBJ_DIR}" || die

	CC="$(tc-getCC)" CXX="$(tc-getCXX)" LD="$(tc-getLD)" \
	MOZ_MAKE_FLAGS="${MAKEOPTS}" SHELL="${SHELL}" \
	emake -f "${S}"/client.mk

	# Only build enigmail extension if crypt enabled.
	if use crypt ; then
		einfo "Building enigmail"
		pushd "${WORKDIR}"/enigmail &>/dev/null || die
		emake -j1
		emake -j1 xpi
		popd &>/dev/null || die
	fi
}

src_install() {
	declare MOZILLA_FIVE_HOME="/usr/$(get_libdir)/${PN}"
	DICTPATH="\"${EPREFIX}/usr/share/myspell\""

	declare emid
	cd "${BUILD_OBJ_DIR}" || die

	# Copy our preference before omnijar is created.
	cp "${FILESDIR}"/thunderbird-gentoo-default-prefs-1.js-1 \
		"${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	# Set default path to search for dictionaries.
	echo "pref(\"spellchecker.dictionary_path\", ${DICTPATH});" \
		>> "${BUILD_OBJ_DIR}/dist/bin/defaults/pref/all-gentoo.js" \
		|| die

	# Pax mark xpcshell for hardened support, only used for startupcache creation.
	pax-mark m "${BUILD_OBJ_DIR}"/mozilla/dist/bin/xpcshell

	MOZ_MAKE_FLAGS="${MAKEOPTS}" \
	emake DESTDIR="${D}" install

	# Install language packs
	mozlinguas_src_install

	if ! use bindist; then
		newicon "${S}"/other-licenses/branding/thunderbird/content/icon48.png thunderbird-icon.png
		domenu "${FILESDIR}"/icon/${PN}.desktop
	else
		newicon "${S}"/mail/branding/aurora/content/icon48.png thunderbird-icon-unbranded.png
		newmenu "${FILESDIR}"/icon/${PN}-unbranded.desktop \
			${PN}.desktop

		sed -i -e "s:Mozilla\ Thunderbird:EarlyBird:g" \
			"${ED}"/usr/share/applications/${PN}.desktop
	fi

	local emid
	# stage extra locales for lightning and install over existing
	mozlinguas_xpistage_langpacks "${BUILD_OBJ_DIR}"/dist/xpi-stage/lightning \
		"${WORKDIR}"/lightning-${MOZ_LIGHTNING_VER} lightning calendar

	emid='{e2fda1a4-762b-4020-b5ad-a41df1933103}'
	mkdir -p "${T}/${emid}" || die
	cp -RLp -t "${T}/${emid}" "${BUILD_OBJ_DIR}"/dist/xpi-stage/lightning/* || die
	insinto ${MOZILLA_FIVE_HOME}/distribution/extensions
	doins -r "${T}/${emid}"

	if use lightning; then
		# move lightning out of distribution/extensions and into extensions for app-global install
		mv "${ED}"/${MOZILLA_FIVE_HOME}/{distribution,}/extensions/${emid} || die

		# stage extra locales for gdata-provider and install app-global
		mozlinguas_xpistage_langpacks "${BUILD_OBJ_DIR}"/dist/xpi-stage/gdata-provider \
			"${WORKDIR}"/gdata-provider-${MOZ_LIGHTNING_GDATA_VER}
		emid='{a62ef8ec-5fdc-40c2-873c-223b8a6925cc}'
		mkdir -p "${T}/${emid}" || die
		cp -RLp -t "${T}/${emid}" "${BUILD_OBJ_DIR}"/dist/xpi-stage/gdata-provider/* || die
		insinto ${MOZILLA_FIVE_HOME}/extensions
		doins -r "${T}/${emid}"
	fi

	if use crypt ; then
		local enigmail_xpipath="${WORKDIR}/enigmail/build"
		cd "${T}" || die
		unzip "${enigmail_xpipath}"/enigmail*.xpi install.rdf || die
		emid=$(sed -n '/<em:id>/!d; s/.*\({.*}\).*/\1/; p; q' install.rdf)

		dodir ${MOZILLA_FIVE_HOME}/extensions/${emid} || die
		cd "${ED}"${MOZILLA_FIVE_HOME}/extensions/${emid} || die
		unzip "${enigmail_xpipath}"/enigmail*.xpi || die
	fi

	# Required in order for jit to work on hardened, for mozilla-31 and above
	use jit && pax-mark pm "${ED}"${MOZILLA_FIVE_HOME}/{thunderbird,thunderbird-bin}

	# Plugin-container needs to be pax-marked for hardened to ensure plugins such as flash
	# continue to work as expected.
	pax-mark m "${ED}"${MOZILLA_FIVE_HOME}/plugin-container

	if use minimal; then
		rm -r "${ED}"/usr/include "${ED}"${MOZILLA_FIVE_HOME}/{idl,include,lib,sdk} || \
			die "Failed to remove sdk and headers"
	fi
}

pkg_postinst() {
	if use crypt; then
		local peimpl=$(eselect --brief --colour=no pinentry show)
		case "${peimpl}" in
		*gtk*|*qt*) ;;
		*)	ewarn "The pinentry front-end currently selected is not one supported by thunderbird."
			ewarn "You may be prompted for your password in an inaccessible shell!!"
			ewarn "Please use 'eselect pinentry' to select either the gtk or qt front-end"
			;;
		esac
	fi
	elog
	elog "If you experience problems with plugins please issue the"
	elog "following command : rm \${HOME}/.thunderbird/*/extensions.sqlite ,"
	elog "then restart thunderbird"
	if ! use lightning; then
		elog
		elog "If calendar fails to show up in extensions please open config editor"
		elog "and set extensions.lastAppVersion to 38.0.0 to force a reload. If this"
		elog "fails to show the calendar extension after restarting with above change"
		elog "please file a bug report."
	fi
}
