# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: kde4-base.eclass
# @MAINTAINER:
# kde@gentoo.org
# @BLURB: This eclass provides functions for kde 4.X ebuilds
# @DESCRIPTION:
# The kde4-base.eclass provides support for building KDE4 based ebuilds
# and KDE4 applications.
#
# NOTE: KDE 4 ebuilds currently support EAPI 5. This will be
# reviewed over time as new EAPI versions are approved.

if [[ -z ${_KDE4_BASE_ECLASS} ]]; then
_KDE4_BASE_ECLASS=1

# @ECLASS-VARIABLE: KDE_SELINUX_MODULE
# @DESCRIPTION:
# If set to "none", do nothing.
# For any other value, add selinux to IUSE, and depending on that useflag
# add a dependency on sec-policy/selinux-${KDE_SELINUX_MODULE} to (R)DEPEND
: ${KDE_SELINUX_MODULE:=none}

# @ECLASS-VARIABLE: VIRTUALDBUS_TEST
# @DESCRIPTION:
# If defined, launch and use a private dbus session during src_test.

# @ECLASS-VARIABLE: VIRTUALX_REQUIRED
# @DESCRIPTION:
# For proper description see virtualx.eclass manpage.
# Here we redefine default value to be manual, if your package needs virtualx
# for tests you should proceed with setting VIRTUALX_REQUIRED=test.
: ${VIRTUALX_REQUIRED:=manual}

inherit kde4-functions toolchain-funcs fdo-mime flag-o-matic gnome2-utils virtualx versionator eutils multilib

if [[ ${KDE_BUILD_TYPE} = live ]]; then
	case ${KDE_SCM} in
		svn) inherit subversion ;;
		git) inherit git-r3 ;;
	esac
fi

# @ECLASS-VARIABLE: CMAKE_REQUIRED
# @DESCRIPTION:
# Specify if cmake buildsystem is being used. Possible values are 'always' and 'never'.
# Please note that if it's set to 'never' you need to explicitly override following phases:
# src_configure, src_compile, src_test and src_install.
# Defaults to 'always'.
: ${CMAKE_REQUIRED:=always}
if [[ ${CMAKE_REQUIRED} = always ]]; then
	buildsystem_eclass="cmake-utils"
	export_fns="src_configure src_compile src_test src_install"
fi

# @ECLASS-VARIABLE: KDE_MINIMAL
# @DESCRIPTION:
# This variable is used when KDE_REQUIRED is set, to specify required KDE minimal
# version for apps to work. Currently defaults to 4.4
# One may override this variable to raise version requirements.
# Note that it is fixed to ${PV} for kde-base packages.
KDE_MINIMAL="${KDE_MINIMAL:-4.4}"

# Set slot for KDEBASE known packages
case ${KDEBASE} in
	kde-base)
		SLOT=4/$(get_version_component_range 1-2)
		KDE_MINIMAL="${PV}"
		;;
	kdevelop)
		if [[ ${KDE_BUILD_TYPE} = live ]]; then
			# @ECLASS-VARIABLE: KDEVELOP_VERSION
			# @DESCRIPTION:
			# Specifies KDevelop version. Default is 4.0.0 for tagged packages and 9999 for live packages.
			# Applies to KDEBASE=kdevelop only.
			KDEVELOP_VERSION="${KDEVELOP_VERSION:-4.9999}"
			# @ECLASS-VARIABLE: KDEVPLATFORM_VERSION
			# @DESCRIPTION:
			# Specifies KDevplatform version. Default is 1.0.0 for tagged packages and 9999 for live packages.
			# Applies to KDEBASE=kdevelop only.
			KDEVPLATFORM_VERSION="${KDEVPLATFORM_VERSION:-4.9999}"
		else
			case ${PN} in
				kdevelop)
					KDEVELOP_VERSION=${PV}
					KDEVPLATFORM_VERSION="$(($(get_major_version)-3)).$(get_after_major_version)"
					;;
				kdevplatform|kdevelop-php*|kdevelop-python)
					KDEVELOP_VERSION="$(($(get_major_version)+3)).$(get_after_major_version)"
					KDEVPLATFORM_VERSION=${PV}
					;;
				*)
					KDEVELOP_VERSION="${KDEVELOP_VERSION:-4.0.0}"
					KDEVPLATFORM_VERSION="${KDEVPLATFORM_VERSION:-1.0.0}"
			esac
		fi
		SLOT="4"
		;;
esac

inherit ${buildsystem_eclass}

EXPORT_FUNCTIONS pkg_setup src_unpack src_prepare ${export_fns} pkg_preinst pkg_postinst pkg_postrm

unset buildsystem_eclass
unset export_fns

# @ECLASS-VARIABLE: DECLARATIVE_REQUIRED
# @DESCRIPTION:
# Is qtdeclarative required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
DECLARATIVE_REQUIRED="${DECLARATIVE_REQUIRED:-never}"

# @ECLASS-VARIABLE: QTHELP_REQUIRED
# @DESCRIPTION:
# Is qthelp required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
QTHELP_REQUIRED="${QTHELP_REQUIRED:-never}"

# @ECLASS-VARIABLE: OPENGL_REQUIRED
# @DESCRIPTION:
# Is qtopengl required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
OPENGL_REQUIRED="${OPENGL_REQUIRED:-never}"

# @ECLASS-VARIABLE: MULTIMEDIA_REQUIRED
# @DESCRIPTION:
# Is qtmultimedia required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
MULTIMEDIA_REQUIRED="${MULTIMEDIA_REQUIRED:-never}"

# @ECLASS-VARIABLE: CPPUNIT_REQUIRED
# @DESCRIPTION:
# Is cppunit required for tests? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
CPPUNIT_REQUIRED="${CPPUNIT_REQUIRED:-never}"

# @ECLASS-VARIABLE: KDE_REQUIRED
# @DESCRIPTION:
# Is kde required? Possible values are 'always', 'optional' and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'always'
# If set to 'always' or 'optional', KDE_MINIMAL may be overriden as well.
# Note that for kde-base packages this variable is fixed to 'always'.
KDE_REQUIRED="${KDE_REQUIRED:-always}"

# @ECLASS-VARIABLE: KDE_HANDBOOK
# @DESCRIPTION:
# Set to enable handbook in application. Possible values are 'always', 'optional'
# (handbook USE flag) and 'never'.
# This variable must be set before inheriting any eclasses. Defaults to 'never'.
# It adds default handbook dirs for kde-base packages to KMEXTRA and in any case it
# ensures buildtime and runtime dependencies.
KDE_HANDBOOK="${KDE_HANDBOOK:-never}"

# @ECLASS-VARIABLE: KDE_LINGUAS_LIVE_OVERRIDE
# @DESCRIPTION:
# Set this varible if you want your live package to manage its
# translations. (Mostly all kde ebuilds does not ship documentation
# and translations in live ebuilds)
if [[ ${KDE_BUILD_TYPE} == live && -z ${KDE_LINGUAS_LIVE_OVERRIDE} ]]; then
	# Kdebase actualy provides the handbooks even for live stuff
	[[ ${KDEBASE} == kde-base ]] || KDE_HANDBOOK=never
	KDE_LINGUAS=""
fi

# Setup packages inheriting this eclass
case ${KDEBASE} in
	kde-base)
		HOMEPAGE="https://www.kde.org/"
		LICENSE="GPL-2"
		if [[ ${KDE_BUILD_TYPE} = live && -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
			# Disable tests for live ebuilds by default
			RESTRICT+=" test"
		fi

		# This code is to prevent portage from searching GENTOO_MIRRORS for
		# packages that will never be mirrored. (As they only will ever be in
		# the overlay).
		case ${PV} in
			*9999* | 4.?.[6-9]? | 4.??.[6-9]? | ??.?.[6-9]? | ??.??.[6-9]?)
				RESTRICT+=" mirror"
				;;
		esac
		;;
	kdevelop)
		HOMEPAGE="https://www.kdevelop.org/"
		LICENSE="GPL-2"
		;;
esac

# @ECLASS-VARIABLE: QT_MINIMAL
# @DESCRIPTION:
# Determine version of qt we enforce as minimal for the package.
QT_MINIMAL="${QT_MINIMAL:-4.8.5}"

# Declarative dependencies
qtdeclarativedepend="
	>=dev-qt/qtdeclarative-${QT_MINIMAL}:4
"
case ${DECLARATIVE_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtdeclarativedepend}"
		;;
	optional)
		IUSE+=" declarative"
		COMMONDEPEND+=" declarative? ( ${qtdeclarativedepend} )"
		;;
	*) ;;
esac
unset qtdeclarativedepend

# QtHelp dependencies
qthelpdepend="
	>=dev-qt/qthelp-${QT_MINIMAL}:4
"
case ${QTHELP_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qthelpdepend}"
		;;
	optional)
		IUSE+=" qthelp"
		COMMONDEPEND+=" qthelp? ( ${qthelpdepend} )"
		;;
esac
unset qthelpdepend

# OpenGL dependencies
qtopengldepend="
	>=dev-qt/qtopengl-${QT_MINIMAL}:4
"
case ${OPENGL_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtopengldepend}"
		;;
	optional)
		IUSE+=" opengl"
		COMMONDEPEND+=" opengl? ( ${qtopengldepend} )"
		;;
	*) ;;
esac
unset qtopengldepend

# MultiMedia dependencies
qtmultimediadepend="
	>=dev-qt/qtmultimedia-${QT_MINIMAL}:4
"
case ${MULTIMEDIA_REQUIRED} in
	always)
		COMMONDEPEND+=" ${qtmultimediadepend}"
		;;
	optional)
		IUSE+=" multimedia"
		COMMONDEPEND+=" multimedia? ( ${qtmultimediadepend} )"
		;;
	*) ;;
esac
unset qtmultimediadepend

# CppUnit dependencies
cppuintdepend="
	dev-util/cppunit
"
case ${CPPUNIT_REQUIRED} in
	always)
		DEPEND+=" ${cppuintdepend}"
		;;
	optional)
		IUSE+=" test"
		DEPEND+=" test? ( ${cppuintdepend} )"
		;;
	*) ;;
esac
unset cppuintdepend

# KDE dependencies
# Qt accessibility classes are needed in various places, bug 325461
kdecommondepend="
	dev-lang/perl
	>=dev-qt/qt3support-${QT_MINIMAL}:4[accessibility]
	>=dev-qt/qtcore-${QT_MINIMAL}:4[qt3support,ssl]
	>=dev-qt/qtdbus-${QT_MINIMAL}:4
	>=dev-qt/designer-${QT_MINIMAL}:4
	>=dev-qt/qtgui-${QT_MINIMAL}:4[accessibility,dbus(+)]
	>=dev-qt/qtscript-${QT_MINIMAL}:4
	>=dev-qt/qtsql-${QT_MINIMAL}:4[qt3support]
	>=dev-qt/qtsvg-${QT_MINIMAL}:4
	>=dev-qt/qttest-${QT_MINIMAL}:4
	>=dev-qt/qtwebkit-${QT_MINIMAL}:4
"

if [[ ${PN} != kdelibs ]]; then
	kdecommondepend+=" $(add_kdebase_dep kdelibs)"
	if [[ ${KDEBASE} = kdevelop ]]; then
		if [[ ${PN} != kdevplatform ]]; then
			# @ECLASS-VARIABLE: KDEVPLATFORM_REQUIRED
			# @DESCRIPTION:
			# Specifies whether kdevplatform is required. Possible values are 'always' (default) and 'never'.
			# Applies to KDEBASE=kdevelop only.
			KDEVPLATFORM_REQUIRED="${KDEVPLATFORM_REQUIRED:-always}"
			case ${KDEVPLATFORM_REQUIRED} in
				always)
					kdecommondepend+="
						>=dev-util/kdevplatform-${KDEVPLATFORM_VERSION}:4
					"
					;;
				*) ;;
			esac
		fi
	fi
fi

kdedepend="
	dev-util/automoc
	virtual/pkgconfig
	!aqua? (
		>=x11-libs/libXtst-1.1.0
		x11-proto/xf86vidmodeproto
	)
"

kderdepend=""

if [[ ${CATEGORY} == kde-apps ]]; then
	kderdepend+=" !kde-base/${PN}:4"
fi

# all packages needs oxygen icons for basic iconset
if [[ ${PN} != oxygen-icons ]]; then
	kderdepend+=" kde-frameworks/oxygen-icons"
fi

# add a dependency over kde4-l10n
if [[ ${KDEBASE} != "kde-base" && -n ${KDE_LINGUAS} ]]; then
	for _lingua in ${KDE_LINGUAS}; do
		# if our package has linguas, pull in kde4-l10n with selected lingua enabled,
		# but only for selected ones.
		# this can't be done on one line because if user doesn't use any localisation
		# then he is probably not interested in kde4-l10n at all.
		kderdepend+="
		linguas_${_lingua}? ( $(add_kdeapps_dep kde4-l10n "linguas_${_lingua}(+)") )
		"
	done
	unset _lingua
fi

kdehandbookdepend="
	app-text/docbook-xml-dtd:4.2
	app-text/docbook-xsl-stylesheets
"
kdehandbookrdepend="
	$(add_kdebase_dep kdelibs 'handbook')
"
case ${KDE_HANDBOOK} in
	always)
		kdedepend+=" ${kdehandbookdepend}"
		[[ ${PN} != kdelibs ]] && kderdepend+=" ${kdehandbookrdepend}"
		;;
	optional)
		IUSE+=" +handbook"
		kdedepend+=" handbook? ( ${kdehandbookdepend} )"
		[[ ${PN} != kdelibs ]] && kderdepend+=" handbook? ( ${kdehandbookrdepend} )"
		;;
	*) ;;
esac
unset kdehandbookdepend kdehandbookrdepend

case ${KDE_SELINUX_MODULE} in
	none)	;;
	*)
		IUSE+=" selinux"
		kderdepend+=" selinux? ( sec-policy/selinux-${KDE_SELINUX_MODULE} )"
		;;
esac

# We always need the aqua useflag because otherwise we cannot = refer to it inside
# add_kdebase_dep. This was always kind of a bug, but came to light with EAPI=5
# (where referring to a use flag not in IUSE masks the ebuild).
# The only alternative would be to prohibit using add_kdebase_dep if KDE_REQUIRED=never
IUSE+=" aqua"

case ${KDE_REQUIRED} in
	always)
		[[ -n ${kdecommondepend} ]] && COMMONDEPEND+=" ${kdecommondepend}"
		[[ -n ${kdedepend} ]] && DEPEND+=" ${kdedepend}"
		[[ -n ${kderdepend} ]] && RDEPEND+=" ${kderdepend}"
		;;
	optional)
		IUSE+=" kde"
		[[ -n ${kdecommondepend} ]] && COMMONDEPEND+=" kde? ( ${kdecommondepend} )"
		[[ -n ${kdedepend} ]] && DEPEND+=" kde? ( ${kdedepend} )"
		[[ -n ${kderdepend} ]] && RDEPEND+=" kde? ( ${kderdepend} )"
		;;
	*) ;;
esac

unset kdecommondepend kdedepend kderdepend

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: COMMONDEPEND is ${COMMONDEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: DEPEND (only) is ${DEPEND}"
debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: RDEPEND (only) is ${RDEPEND}"

# Accumulate dependencies set by this eclass
DEPEND+=" ${COMMONDEPEND}"
RDEPEND+=" ${COMMONDEPEND}"
unset COMMONDEPEND

# Fetch section - If the ebuild's category is not 'kde-base' and if it is not a
# kdevelop ebuild, the URI should be set in the ebuild itself
_calculate_src_uri() {
	debug-print-function ${FUNCNAME} "$@"

	local _kmname _kmname_pv

	# we calculate URI only for known KDEBASE modules
	[[ -n ${KDEBASE} ]] || return

	# calculate tarball module name
	if [[ -n ${KMNAME} ]]; then
		_kmname="${KMNAME}"
	else
		_kmname=${PN}
	fi
	_kmname_pv="${_kmname}-${PV}"
	case ${KDEBASE} in
		kde-base)
			case ${PV} in
				4.4.11.1)
					# KDEPIM 4.4, special case
					# TODO: Remove this part when KDEPIM 4.4 gets out of the tree
					SRC_URI="mirror://kde/stable/kdepim-${PV}/src/${_kmname_pv}.tar.bz2" ;;
				4.4.20*)
					# KDEPIM 4.4 no-akonadi branch, special case
					# TODO: Remove this part when KDEPIM 4.4 gets out of the tree
					SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${_kmname_pv}.tar.xz" ;;
				4.?.[6-9]? | 4.??.[6-9]?)
					# Unstable KDE SC releases
					SRC_URI="mirror://kde/unstable/${PV}/src/${_kmname_pv}.tar.xz" ;;
				4.11.19)
					# Part of 15.04.1 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/stable/applications/15.04.1/src/${_kmname_pv}.tar.xz" ;;
				4.11.22)
					# Part of 15.08.0 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/stable/applications/15.08.0/src/${_kmname_pv}.tar.xz" ;;
				4.14.3)
					# Last SC release
					SRC_URI="mirror://kde/stable/${PV}/src/${_kmname_pv}.tar.xz" ;;
				4.14.8)
					# Part of 15.04.1 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/stable/applications/15.04.1/src/${_kmname_pv}.tar.xz" ;;
				4.14.10)
					# Part of 15.04.3 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/stable/applications/15.04.3/src/${_kmname_pv}.tar.xz" ;;
				4.14.13)
					# Part of 15.08.2 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/stable/applications/15.08.2/src/${_kmname_pv}.tar.xz" ;;
				4.14.14)
					# Part of 15.08.3 actually, sigh. Not stable for next release!
					SRC_URI="mirror://kde/stable/applications/15.08.3/src/${_kmname_pv}.tar.xz" ;;
				??.?.[6-9]? | ??.??.[4-9]?)
					# Unstable KDE Applications releases
					SRC_URI="mirror://kde/unstable/applications/${PV}/src/${_kmname}-${PV}.tar.xz" ;;
				*)
					# Stable KDE Applications releases
					SRC_URI="mirror://kde/stable/applications/${PV}/src/${_kmname}-${PV}.tar.xz"
				;;
			esac
			;;
		kdevelop|kdevelop-php*|kdevplatform)
			case ${KDEVELOP_VERSION} in
				4.[123].[6-9]*) SRC_URI="mirror://kde/unstable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz" ;;
				*) SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${P}.tar.xz" ;;
			esac
			;;
	esac
}

_calculate_live_repo() {
	debug-print-function ${FUNCNAME} "$@"

	SRC_URI=""
	case ${KDE_SCM} in
		svn)
			# Determine branch URL based on live type
			local branch_prefix
			case ${PV} in
				9999*)
					# trunk
					branch_prefix="trunk/KDE"
					;;
				*)
					# branch
					branch_prefix="branches/KDE/$(get_kde_version)"

					if [[ ${PV} == ??.??.49.9999 && ${CATEGORY} = kde-apps ]]; then
						branch_prefix="branches/Applications/$(get_kde_version)"
					fi

					# @ECLASS-VARIABLE: ESVN_PROJECT_SUFFIX
					# @DESCRIPTION
					# Suffix appended to ESVN_PROJECT depending on fetched branch.
					# Defaults is empty (for -9999 = trunk), and "-${PV}" otherwise.
					ESVN_PROJECT_SUFFIX="-${PV}"
					;;
			esac
			# @ECLASS-VARIABLE: ESVN_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anonsvn) with anything else you might want to use.
			ESVN_MIRROR=${ESVN_MIRROR:=svn://anonsvn.kde.org/home/kde}
			# Split ebuild, or extragear stuff
			if [[ -n ${KMNAME} ]]; then
				ESVN_PROJECT="${KMNAME}${ESVN_PROJECT_SUFFIX}"
				if [[ -z ${KMNOMODULE} ]] && [[ -z ${KMMODULE} ]]; then
					KMMODULE="${PN}"
				fi
				# Split kde-base/ ebuilds: (they reside in trunk/KDE)
				case ${KMNAME} in
					kdebase-*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdebase/${KMNAME#kdebase-}"
						;;
					kdelibs-*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/kdelibs/${KMNAME#kdelibs-}"
						;;
					kdereview*)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						;;
					kdesupport)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
						;;
					kde*)
						ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${KMNAME}"
						;;
					extragear*|playground*)
						# Unpack them in toplevel dir, so that they won't conflict with kde4-meta
						# build packages from same svn location.
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
						;;
					*)
						ESVN_REPO_URI="${ESVN_MIRROR}/trunk/${KMNAME}/${KMMODULE}"
						;;
				esac
			else
				# kdelibs, kdepimlibs
				ESVN_REPO_URI="${ESVN_MIRROR}/${branch_prefix}/${PN}"
				ESVN_PROJECT="${PN}${ESVN_PROJECT_SUFFIX}"
			fi
			# @ECLASS-VARIABLE: ESVN_UP_FREQ
			# @DESCRIPTION:
			# This variable is used for specifying the timeout between svn synces
			# for kde-base modules. Does not affect misc apps.
			# Default value is 1 hour.
			[[ ${KDEBASE} = kde-base ]] && ESVN_UP_FREQ=${ESVN_UP_FREQ:-1}
			;;
		git)
			local _kmname
			# @ECLASS-VARIABLE: EGIT_MIRROR
			# @DESCRIPTION:
			# This variable allows easy overriding of default kde mirror service
			# (anongit) with anything else you might want to use.
			EGIT_MIRROR=${EGIT_MIRROR:=git://anongit.kde.org}

			# @ECLASS-VARIABLE: EGIT_REPONAME
			# @DESCRIPTION:
			# This variable allows overriding of default repository
			# name. Specify only if this differ from PN and KMNAME.
			if [[ -n ${EGIT_REPONAME} ]]; then
				# the repository and kmname different
				_kmname=${EGIT_REPONAME}
			elif [[ -n ${KMNAME} ]]; then
				_kmname=${KMNAME}
			else
				_kmname=${PN}
			fi

			# default branching
			[[ ${PV} != 4.9999* && ${PV} != 9999 && ${KDEBASE} == kde-base ]] && \
				EGIT_BRANCH="KDE/$(get_kde_version)"

			# Applications branching
			[[ ${PV} == ??.??.49.9999 && ${KDEBASE} == kde-base ]] && \
				EGIT_BRANCH="Applications/$(get_kde_version)"

			# default repo uri
			EGIT_REPO_URI+=( "${EGIT_MIRROR}/${_kmname}" )

			debug-print "${FUNCNAME}: Repository: ${EGIT_REPO_URI}"
			debug-print "${FUNCNAME}: Branch: ${EGIT_BRANCH}"
			;;
	esac
}

case ${KDE_BUILD_TYPE} in
	live) _calculate_live_repo ;;
	*) _calculate_src_uri ;;
esac

debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"

# @ECLASS-VARIABLE: PREFIX
# @DESCRIPTION:
# Set the installation PREFIX for non kde-base applications. It defaults to /usr.
# kde-base packages go into KDE4 installation directory (/usr).
# No matter the PREFIX, package will be built against KDE installed in /usr.

# @FUNCTION: kde4-base_pkg_setup
# @DESCRIPTION:
# Do some basic settings
kde4-base_pkg_setup() {
	debug-print-function ${FUNCNAME} "$@"

	if has handbook ${IUSE} || has "+handbook" ${IUSE} && [ "${KDE_HANDBOOK}" != optional ] ; then
		eqawarn "Handbook support is enabled via KDE_HANDBOOK=optional in the ebuild."
		eqawarn "Please do not just set IUSE=handbook, as this leads to dependency errors."
	fi

	# Don't set KDEHOME during compilation, it will cause access violations
	unset KDEHOME

	# Check if gcc compiler is fresh enough.
	# In theory should be in pkg_pretend but we check it only for kdelibs there
	# and for others we do just quick scan in pkg_setup because pkg_pretend
	# executions consume quite some time (ie. when merging 300 packages at once will cause 300 checks)
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-major-version) -lt 4 ]] || \
				( [[ $(gcc-major-version) -eq 4 && $(gcc-minor-version) -le 6 ]] ) \
			&& die "Sorry, but gcc-4.6 and earlier wont work for some KDE packages."
	fi

	KDEDIR=/usr
	: ${PREFIX:=/usr}
	EKDEDIR=${EPREFIX}/usr

	# Point to correct QT plugins path
	QT_PLUGIN_PATH="${EPREFIX}/usr/$(get_libdir)/kde4/plugins/"

	# Fix XDG collision with sandbox
	export XDG_CONFIG_HOME="${T}"
}

# @FUNCTION: kde4-base_src_unpack
# @DESCRIPTION:
# This function unpacks the source tarballs for KDE4 applications.
kde4-base_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ${KDE_BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn)
				subversion_src_unpack
				;;
			git)
				git-r3_src_unpack
				;;
		esac
	else
		unpack ${A}
	fi
}

# @FUNCTION: kde4-base_src_prepare
# @DESCRIPTION:
# General pre-configure and pre-compile function for KDE4 applications.
# It also handles translations if KDE_LINGUAS is defined. See KDE_LINGUAS and
# enable_selected_linguas() and enable_selected_doc_linguas()
# in kde4-functions.eclass(5) for further details.
kde4-base_src_prepare() {
	debug-print-function ${FUNCNAME} "$@"

	# enable handbook and linguas only when not using live ebuild

	# Only enable selected languages, used for KDE extragear apps.
	if [[ -n ${KDE_LINGUAS} ]]; then
		enable_selected_linguas
	fi

	# Enable/disable handbooks for kde4-base packages
	# kde4-l10n inherits kde4-base but is metapackage, so no check for doc
	# kdelibs inherits kde4-base but handle installing the handbook itself
	if ! has kde4-meta ${INHERITED} && in_iuse handbook; then
		if [[ ${KDEBASE} == kde-base ]]; then
			if [[ ${PN} != kde4-l10n && ${PN} != kdepim-l10n && ${PN} != kdelibs ]] && use !handbook; then
				# documentation in kde4-functions
				: ${KDE_DOC_DIRS:=doc}
				local dir
				for dir in ${KDE_DOC_DIRS}; do
					sed -e "\!^[[:space:]]*add_subdirectory[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-e "\!^[[:space:]]*ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-e "\!^[[:space:]]*macro_optional_add_subdirectory[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-e "\!^[[:space:]]*MACRO_OPTIONAL_ADD_SUBDIRECTORY[[:space:]]*([[:space:]]*${dir}[[:space:]]*)!s/^/#DONOTCOMPILE /" \
						-i CMakeLists.txt || die "failed to comment out handbook"
				done
			fi
		else
			enable_selected_doc_linguas
		fi
	fi

	# SCM bootstrap
	if [[ ${KDE_BUILD_TYPE} = live ]]; then
		case ${KDE_SCM} in
			svn) subversion_src_prepare ;;
		esac
	fi

	# Apply patches, cmake-utils does the job already
	cmake-utils_src_prepare

	# Save library dependencies
	if [[ -n ${KMSAVELIBS} ]] ; then
		save_library_dependencies
	fi

	# Inject library dependencies
	if [[ -n ${KMLOADLIBS} ]] ; then
		load_library_dependencies
	fi

	# Hack for manuals relying on outdated DTD, only outside kde-base/...
	if [[ -z ${KDEBASE} ]]; then
		find "${S}" -name "*.docbook" \
			-exec sed -i -r \
				-e 's:-//KDE//DTD DocBook XML V4\.1(\..)?-Based Variant V1\.[01]//EN:-//KDE//DTD DocBook XML V4.2-Based Variant V1.1//EN:g' {} + \
			|| die 'failed to fix DocBook variant version'
	fi
}

# @FUNCTION: kde4-base_src_configure
# @DESCRIPTION:
# Function for configuring the build of KDE4 applications.
kde4-base_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	# Build tests in src_test only, where we override this value
	local cmakeargs=(-DKDE4_BUILD_TESTS=OFF)

	if use_if_iuse debug; then
		# Set "real" debug mode
		CMAKE_KDE_BUILD_TYPE="Debugfull"
	else
		# Handle common release builds
		append-cppflags -DQT_NO_DEBUG
	fi

	# Set distribution name
	[[ ${PN} = kdelibs ]] && cmakeargs+=(-DKDE_DISTRIBUTION_TEXT=Gentoo)

	# Here we set the install prefix
	tc-is-cross-compiler || cmakeargs+=(-DCMAKE_INSTALL_PREFIX="${EPREFIX}${PREFIX}")

	# Use colors
	QTEST_COLORED=1

	# Shadow existing installations
	unset KDEDIRS

	#qmake -query QT_INSTALL_LIBS unavailable when cross-compiling
	tc-is-cross-compiler && cmakeargs+=(-DQT_LIBRARY_DIR=${ROOT}/usr/$(get_libdir)/qt4)
	#kde-config -path data unavailable when cross-compiling
	tc-is-cross-compiler && cmakeargs+=(-DKDE4_DATA_DIR=${ROOT}/usr/share/apps/)

	# sysconf needs to be /etc, not /usr/etc
	cmakeargs+=(-DSYSCONF_INSTALL_DIR="${EPREFIX}"/etc)

	if [[ $(declare -p mycmakeargs 2>&-) != "declare -a mycmakeargs="* ]]; then
		if [[ ${mycmakeargs} ]]; then
			eqawarn "mycmakeargs should always be declared as an array, not a string"
		fi
		mycmakeargs=(${mycmakeargs})
	fi

	mycmakeargs=("${cmakeargs[@]}" "${mycmakeargs[@]}")

	cmake-utils_src_configure
}

# @FUNCTION: kde4-base_src_compile
# @DESCRIPTION:
# General function for compiling KDE4 applications.
kde4-base_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	cmake-utils_src_compile "$@"
}

# @FUNCTION: kde4-base_src_test
# @DESCRIPTION:
# Function for testing KDE4 applications.
kde4-base_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	local kded4_pid

	_test_runner() {
		if [[ -n "${VIRTUALDBUS_TEST}" ]]; then
			export $(dbus-launch)
			kded4 2>&1 > /dev/null &
			kded4_pid=$!
		fi

		cmake-utils_src_test
	}

	# When run as normal user during ebuild development with the ebuild command, the
	# kde tests tend to access the session DBUS. This however is not possible in a real
	# emerge or on the tinderbox.
	# > make sure it does not happen, so bad tests can be recognized and disabled
	unset DBUS_SESSION_BUS_ADDRESS DBUS_SESSION_BUS_PID

	# Override this value, set in kde4-base_src_configure()
	mycmakeargs+=(-DKDE4_BUILD_TESTS=ON)
	cmake-utils_src_configure
	kde4-base_src_compile

	if [[ ${VIRTUALX_REQUIRED} == always || ${VIRTUALX_REQUIRED} == test ]]; then
		# check for sanity if anyone already redefined VIRTUALX_COMMAND from the default
		if [[ ${VIRTUALX_COMMAND} != emake ]]; then
			# surprise- we are already INSIDE virtualmake!!!
			debug-print "QA Notice: This version of kde4-base.eclass includes the virtualx functionality."
			debug-print "           You may NOT set VIRTUALX_COMMAND or call virtualmake from the ebuild."
			debug-print "           Setting VIRTUALX_REQUIRED is completely sufficient. See the"
			debug-print "           kde4-base.eclass docs for details... Applying workaround."
			_test_runner
		else
			VIRTUALX_COMMAND="_test_runner" virtualmake
		fi
	else
		_test_runner
	fi

	if [ -n "${kded4_pid}" ] ; then
		kill ${kded4_pid}
	fi

	if [ -n "${DBUS_SESSION_BUS_PID}" ] ; then
		kill ${DBUS_SESSION_BUS_PID}
	fi
}

# @FUNCTION: kde4-base_src_install
# @DESCRIPTION:
# Function for installing KDE4 applications.
kde4-base_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${KMSAVELIBS} ]] ; then
		install_library_dependencies
	fi

	# Install common documentation of KDE4 applications
	local doc
	if ! has kde4-meta ${INHERITED}; then
		for doc in "${S}"/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
			[[ -f ${doc} && -s ${doc} ]] && dodoc "${doc}"
		done
		for doc in "${S}"/*/{AUTHORS,CHANGELOG,ChangeLog*,README*,NEWS,TODO,HACKING}; do
			[[ -f ${doc} && -s ${doc} ]] && newdoc "${doc}" "$(basename $(dirname ${doc})).$(basename ${doc})"
		done
	fi

	cmake-utils_src_install

	# We don't want ${PREFIX}/share/doc/HTML to be compressed,
	# because then khelpcenter can't find the docs
	[[ -d ${ED}/${PREFIX}/share/doc/HTML ]] &&
		docompress -x ${PREFIX}/share/doc/HTML
}

# @FUNCTION: kde4-base_pkg_preinst
# @DESCRIPTION:
# Function storing icon caches
kde4-base_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_savelist
	if [[ ${KDE_BUILD_TYPE} == live && ${KDE_SCM} == svn ]]; then
		subversion_pkg_preinst
	fi
}

# @FUNCTION: kde4-base_pkg_postinst
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been installed.
kde4-base_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	buildsycoca

	if [[ -z ${I_KNOW_WHAT_I_AM_DOING} ]]; then
		if [[ ${KDE_BUILD_TYPE} = live ]]; then
			echo
			einfo "WARNING! This is an experimental live ebuild of ${CATEGORY}/${PN}"
			einfo "Use it at your own risk."
			einfo "Do _NOT_ file bugs at bugs.gentoo.org because of this ebuild!"
			echo
		fi
		# for all 3rd party soft tell user that he SHOULD install kdebase-startkde or kdebase-runtime-meta
		if [[ ${KDEBASE} != kde-base ]] && \
				! has_version 'kde-apps/kdebase-runtime-meta'; then
			if [[ ${KDE_REQUIRED} == always ]] || ( [[ ${KDE_REQUIRED} == optional ]] && use kde ); then
				echo
				ewarn "WARNING! Your system configuration does not contain \"kde-apps/kdebase-runtime-meta\"."
				ewarn "With this setting you are unsupported by KDE team."
				ewarn "All missing features you report for misc packages will be probably ignored or closed as INVALID."
			fi
		fi
	fi
}

# @FUNCTION: kde4-base_pkg_postrm
# @DESCRIPTION:
# Function to rebuild the KDE System Configuration Cache after an application has been removed.
kde4-base_pkg_postrm() {
	debug-print-function ${FUNCNAME} "$@"

	gnome2_icon_cache_update
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	buildsycoca
}

fi
