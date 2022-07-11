# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Support eclass for packages that are hosted on kde.org infrastructure.
# @DESCRIPTION:
# This eclass is mainly providing facilities for the three upstream release
# groups (Frameworks, Plasma, Gear) to assemble default SRC_URI for tarballs,
# set up git-r3.eclass for stable/master branch versions or restrict access to
# unreleased (packager access only) tarballs in Gentoo KDE overlay, but it may
# be also used by any other package hosted on kde.org.
# It also contains default meta variables for settings not specific to any
# particular build system.

case ${EAPI} in
	7|8) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

if [[ -z ${_KDE_ORG_ECLASS} ]]; then
_KDE_ORG_ECLASS=1

# @ECLASS_VARIABLE: KDE_BUILD_TYPE
# @DESCRIPTION:
# If PV matches "*9999*", this is automatically set to "live".
# Otherwise, this is automatically set to "release".
KDE_BUILD_TYPE="release"
if [[ ${PV} == *9999* ]]; then
	KDE_BUILD_TYPE="live"
fi
export KDE_BUILD_TYPE

if [[ ${KDE_BUILD_TYPE} == live ]]; then
	inherit git-r3
fi

# @ECLASS_VARIABLE: KDE_ORG_CATEGORIES
# @INTERNAL
# @DESCRIPTION:
# Map of ${CATEGORY}=<upstream category> key-value pairs.
declare -A KDE_ORG_CATEGORIES=(
	[app-accessibility]=accessibility
	[app-admin]=system
	[app-backup]=system
	[app-cdr]=utilities
	[app-editors]=utilities
	[app-office]=office
	[app-text]=office
	[dev-libs]=libraries
	[dev-qt]=qt/qt
	[dev-util]=sdk
	[games-board]=games
	[games-kids]=education
	[games-mud]=games
	[kde-frameworks]=frameworks
	[kde-plasma]=plasma
	[mail-client]=pim
	[media-gfx]=graphics
	[media-libs]=libraries
	[media-sound]=multimedia
	[media-video]=multimedia
	[net-firewall]=network
	[net-im]=network
	[net-irc]=network
	[net-libs]=libraries
	[net-misc]=network
	[net-p2p]=network
	[sci-astronomy]=education
	[sci-calculators]=utilities
	[sci-mathematics]=education
	[sci-visualization]=education
	[sys-block]=system
	[sys-libs]=system
	[www-client]=network
	[x11-libs]=libraries
)
readonly KDE_ORG_CATEGORIES

# @ECLASS_VARIABLE: KDE_ORG_CATEGORY
# @PRE_INHERIT
# @DESCRIPTION:
# If unset, default value is mapped from ${CATEGORY} to corresponding upstream
# category on invent.kde.org, with "kde" as fallback value.
: ${KDE_ORG_CATEGORY:=${KDE_ORG_CATEGORIES[${CATEGORY}]:-kde}}

# @ECLASS_VARIABLE: KDE_ORG_COMMIT
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set, instead of a regular release tarball, pull tar.gz snapshot from an
# invent.kde.org repository identified by KDE_ORG_CATEGORY and KDE_ORG_NAME
# at the desired COMMIT ID.

# @ECLASS_VARIABLE: KDE_ORG_NAME
# @PRE_INHERIT
# @DESCRIPTION:
# If unset, default value is set to ${PN}.
# Name of the package as hosted on kde.org mirrors.
: ${KDE_ORG_NAME:=$PN}

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @DESCRIPTION:
# Known schedule URI of package or release group.
: ${KDE_ORG_SCHEDULE_URI:="https://community.kde.org/Schedules"}

# @ECLASS_VARIABLE: KDE_GEAR
# @PRE_INHERIT
# @DESCRIPTION:
# Mark package is being part of KDE Gear release schedule.
# By default, this is set to "false" and does nothing.
# If CATEGORY equals kde-apps, this is automatically set to "true".
# If set to "true", set SRC_URI accordingly.
: ${KDE_GEAR:=false}
if [[ ${CATEGORY} == kde-apps ]]; then
	KDE_GEAR=true
fi

# @ECLASS_VARIABLE: KDE_SELINUX_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# If set to "none", do nothing.
# For any other value, add selinux to IUSE, and depending on that useflag
# add a dependency on sec-policy/selinux-${KDE_SELINUX_MODULE} to (R)DEPEND.
: ${KDE_SELINUX_MODULE:=none}

case ${KDE_SELINUX_MODULE} in
	none)   ;;
	*)
		IUSE+=" selinux"
		RDEPEND+=" selinux? ( sec-policy/selinux-${KDE_SELINUX_MODULE} )"
		;;
esac

# @ECLASS_VARIABLE: KDE_PV_UNRELEASED
# @INTERNAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of package versions that are unreleased upstream.
# Any package matching this will have fetch restriction enabled, and receive
# a proper error message via pkg_nofetch.

# @ECLASS_VARIABLE: KDE_ORG_UNRELEASED
# @DESCRIPTION:
# If set to "true" fetch restriction will be enabled, and a proper error
# message displayed via pkg_nofetch.
KDE_ORG_UNRELEASED=false
has ${PV} "${KDE_PV_UNRELEASED[*]}" && KDE_ORG_UNRELEASED=true
[[ ${KDE_ORG_UNRELEASED} == true ]] && RESTRICT+=" fetch"

# @ECLASS_VARIABLE: EGIT_MIRROR
# @DESCRIPTION:
# This variable allows easy overriding of default kde mirror service
# (anongit) with anything else you might want to use.

# @ECLASS_VARIABLE: EGIT_REPONAME
# @DESCRIPTION:
# This variable allows overriding of default repository name.
# Specify only if this differs from PN and KDE_ORG_NAME.

HOMEPAGE="https://kde.org/"

case ${CATEGORY} in
	dev-qt)
		KDE_ORG_NAME=${QT5_MODULE:-${PN}}
		HOMEPAGE="https://community.kde.org/Qt5PatchCollection
			https://invent.kde.org/qt/qt/ https://www.qt.io/"
		;;
	kde-plasma)
		if [[ -z ${_PLASMA_KDE_ORG_ECLASS} ]]; then
			HOMEPAGE="https://kde.org/plasma-desktop"
		fi
		;;
	kde-frameworks)
		if [[ -z ${_FRAMEWORKS_KDE_ORG_ECLASS} ]]; then
			HOMEPAGE="https://kde.org/products/frameworks/"
			SLOT=5/${PV}
			[[ ${KDE_BUILD_TYPE} == release ]] && SLOT=$(ver_cut 1)/$(ver_cut 1-2)
		fi
		;;
	*) ;;
esac

# @FUNCTION: _kde.org_calculate_src_uri
# @INTERNAL
# @DESCRIPTION:
# Determine fetch location for released tarballs
_kde.org_calculate_src_uri() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -n ${KDE_ORG_COMMIT} ]]; then
		SRC_URI="https://invent.kde.org/${KDE_ORG_CATEGORY}/${KDE_ORG_NAME}/-/"
		SRC_URI+="archive/${KDE_ORG_COMMIT}/${KDE_ORG_NAME}-${KDE_ORG_COMMIT}.tar.gz"
		SRC_URI+=" -> ${KDE_ORG_NAME}-${PV}-${KDE_ORG_COMMIT:0:8}.tar.gz"
	fi

	[[ ${KDE_ORG_UNRELEASED} == true ]] && RESTRICT+=" fetch"

	if [[ -n ${_FRAMEWORKS_KDE_ORG_ECLASS} ]] || [[ -n ${_PLASMA_KDE_ORG_ECLASS} ]] || [[ -n ${_GEAR_KDE_ORG_ECLASS} ]] || [[ -n ${KDE_ORG_COMMIT} ]]; then
		return
	fi

	local _src_uri="mirror://kde/"

	if [[ ${KDE_GEAR} == true ]]; then
		case ${PV} in
			??.??.[6-9]? )
				_src_uri+="unstable/release-service/${PV}/src/"
				RESTRICT+=" mirror"
				;;
			*) _src_uri+="stable/release-service/${PV}/src/" ;;
		esac
	fi

	case ${CATEGORY} in
		kde-frameworks)
			_src_uri+="stable/frameworks/$(ver_cut 1-2)/"
			case ${PN} in
				countryflags | \
				kdelibs4support | \
				kdesignerplugin | \
				kdewebkit | \
				khtml | \
				kjs | \
				kjsembed | \
				kmediaplayer | \
				kross | \
				kxmlrpcclient)
					_src_uri+="portingAids/"
					;;
			esac
			;;
		kde-plasma)
			case ${PV} in
				5.??.[6-9]?* )
					_src_uri+="unstable/plasma/$(ver_cut 1-3)/"
					RESTRICT+=" mirror"
					;;
				*) _src_uri+="stable/plasma/$(ver_cut 1-3)/" ;;
			esac
			;;
	esac

	SRC_URI="${_src_uri}${KDE_ORG_NAME}-${PV}.tar.xz"
}

case ${KDE_BUILD_TYPE} in
	live)
		EGIT_MIRROR=${EGIT_MIRROR:=https://invent.kde.org/${KDE_ORG_CATEGORY}}
		EGIT_REPO_URI="${EGIT_MIRROR}/${EGIT_REPONAME:=$KDE_ORG_NAME}.git"

		if [[ ${PV} == 5.??.?.9999 && ${CATEGORY} == dev-qt ]]; then
			EGIT_BRANCH="kde/$(ver_cut 1-2)"
		fi
		;;
	*)
		_kde.org_calculate_src_uri
		debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"
		if [[ -n ${KDE_ORG_COMMIT} ]]; then
			S=${WORKDIR}/${KDE_ORG_NAME}-${KDE_ORG_COMMIT}
			[[ ${CATEGORY} == dev-qt ]] && QT5_BUILD_DIR="${S}_build"
		else
			S=${WORKDIR}/${KDE_ORG_NAME}-${PV}
		fi
		;;
esac

# @FUNCTION: kde.org_pkg_nofetch
# @DESCRIPTION:
# Intended for use in the KDE overlay. If this package matches something in
# KDE_UNRELEASED, display a giant warning that the package has not yet been
# released upstream and should not be used.
kde.org_pkg_nofetch() {
	[[ ${KDE_ORG_UNRELEASED} == true ]] || return
	eerror " _   _ _   _ ____  _____ _     _____    _    ____  _____ ____  "
	eerror "| | | | \ | |  _ \| ____| |   | ____|  / \  / ___|| ____|  _ \ "
	eerror "| | | |  \| | |_) |  _| | |   |  _|   / _ \ \___ \|  _| | | | |"
	eerror "| |_| | |\  |  _ <| |___| |___| |___ / ___ \ ___) | |___| |_| |"
	eerror " \___/|_| \_|_| \_\_____|_____|_____/_/   \_\____/|_____|____/ "
	eerror "                                                               "
	eerror " ____   _    ____ _  __    _    ____ _____ "
	eerror "|  _ \ / \  / ___| |/ /   / \  / ___| ____|"
	eerror "| |_) / _ \| |   | ' /   / _ \| |  _|  _|  "
	eerror "|  __/ ___ \ |___| . \  / ___ \ |_| | |___ "
	eerror "|_| /_/   \_\____|_|\_\/_/   \_\____|_____|"
	eerror
	eerror "${CATEGORY}/${P} has not been released to the public yet"
	eerror "and is only available to packagers right now."
	eerror ""
	eerror "This is not a bug. Please do not file bugs or contact upstream about this."
	eerror ""
	eerror "Please consult the upstream release schedule to see when this "
	eerror "package is scheduled to be released:"
	eerror "${KDE_ORG_SCHEDULE_URI}"
}

# @FUNCTION: kde.org_src_unpack
# @DESCRIPTION:
# Unpack the sources, automatically handling both release and live ebuilds.
kde.org_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	case ${KDE_BUILD_TYPE} in
		live) git-r3_src_unpack ;&
		*) default ;;
	esac
}

fi

EXPORT_FUNCTIONS pkg_nofetch src_unpack
