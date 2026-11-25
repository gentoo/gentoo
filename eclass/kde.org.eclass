# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8 9
# @BLURB: Support eclass for packages that are hosted on kde.org infrastructure.
# @DESCRIPTION:
# This eclass is mainly providing facilities for the three upstream release
# groups (Frameworks, Plasma, Gear) to assemble default SRC_URI for tarballs,
# set up git-r3.eclass for stable/master branch versions or restrict access to
# unreleased (packager access only) tarballs in Gentoo KDE overlay, but it may
# be also used by any other package hosted on kde.org.
# It also contains default meta variables for settings not specific to any
# particular build system.

if [[ -z ${_KDE_ORG_ECLASS} ]]; then
_KDE_ORG_ECLASS=1

case ${EAPI} in
	8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

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
	case ${EAPI} in
		8) inherit eapi9-pipestatus ;&
		*) inherit git-r3 ;;
	esac
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
	[games-puzzle]=games
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
: "${KDE_ORG_CATEGORY:=${KDE_ORG_CATEGORIES[${CATEGORY}]:-kde}}"

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
# Name of the package (repository) as hosted on invent.kde.org.
: "${KDE_ORG_NAME:=$PN}"

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @DESCRIPTION:
# Known schedule URI of package or release group.
: "${KDE_ORG_SCHEDULE_URI:="https://community.kde.org/Schedules"}"

# @ECLASS_VARIABLE: KDE_SELINUX_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# If set to "none", do nothing.
# For any other value, add selinux to IUSE, and depending on that useflag
# add a dependency on sec-policy/selinux-${KDE_SELINUX_MODULE} to (R)DEPEND.
: "${KDE_SELINUX_MODULE:=none}"

# @ECLASS_VARIABLE: KDE_ORG_TAR_PN
# @PRE_INHERIT
# @DESCRIPTION:
# If unset, default value is set to ${KDE_ORG_NAME}.
# Filename sans version of the tarball as hosted on kde.org download mirrors.
# This is used e.g. when upstream's tarball name differs from repository,
# especially after repository moves.
: "${KDE_ORG_TAR_PN:=$KDE_ORG_NAME}"

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

case ${KDE_BUILD_TYPE} in
	live)
		EGIT_MIRROR=${EGIT_MIRROR:=https://invent.kde.org/${KDE_ORG_CATEGORY}}
		EGIT_REPO_URI="${EGIT_MIRROR}/${EGIT_REPONAME:=$KDE_ORG_NAME}.git"
		;;
	*)
		if [[ -n ${KDE_ORG_COMMIT} ]]; then
			_KDE_ORG_TARFILE="${KDE_ORG_NAME}-${PV}-${KDE_ORG_COMMIT:0:8}.tar.gz"
			SRC_URI="mirror://gentoo/${_KDE_ORG_TARFILE}"
			SRC_URI+=" https://invent.kde.org/${KDE_ORG_CATEGORY}/${KDE_ORG_NAME}/-/"
			SRC_URI+="archive/${KDE_ORG_COMMIT}/${KDE_ORG_NAME}-${KDE_ORG_COMMIT}.tar.gz"
			SRC_URI+=" -> ${_KDE_ORG_TARFILE}"
			S=${WORKDIR}/${KDE_ORG_NAME}-${KDE_ORG_COMMIT}
		else
			S=${WORKDIR}/${KDE_ORG_TAR_PN}-${PV}
		fi
		debug-print "${LINENO} ${ECLASS} ${FUNCNAME}: SRC_URI is ${SRC_URI}"
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

# @FUNCTION: _kde.org_live_corrosion_unpack
# @INTERNAL
# @DESCRIPTION:
# Handle rust crates for live packages. Iterates S directory with
# corrosion_import_crate to fetch with cargo_live_src_unpack.
_kde.org_live_corrosion_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	# Need to handle every corrosion "project" individually.
	local path
	while IFS= read -r -d '' path ; do
		S="${path%/*}" cargo_live_src_unpack
	done < <(find "${S}" -type f -iname CMakeLists.txt -print0 | xargs -0 grep -z -Z -l -i corrosion_import_crate; pipestatus || die)
}

# @FUNCTION: kde.org_src_unpack
# @DESCRIPTION:
# Unpack the sources, automatically handling both release and live ebuilds.
# For releases, if cargo.eclass is inherited, call cargo_src_unpack instead of
# default.  For live ebuilds, if both cmake.eclass and cargo.eclass are
# inherited, deal with potential Corrosion.
kde.org_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	# cargo detection, but only if rust_pkg_setup was called (CARGO_OPTIONAL support)
	local isrusty
	if has cargo ${INHERITED} && [[ -n "${CARGO}" ]]; then
		isrusty=true
	fi

	case ${KDE_BUILD_TYPE} in
		live)
			git-r3_src_unpack
			default
			if has cmake ${INHERITED} && [[ ${isrusty} ]]; then
				_kde.org_live_corrosion_unpack
			fi
			;;
		*)
			if [[ ${isrusty} ]]; then
				cargo_src_unpack
			else
				default
			fi
			;;
	esac
}

kde.org_pkg_info() {
	if [[ ${KDE_BUILD_TYPE} = live ]]; then
		echo "WARNING! This is an experimental live ebuild of ${CATEGORY}/${PN}"
		echo "Use it at your own risk."
		echo "Only file bugs at bugs.gentoo.org if convinced that ebuild needs an update!"
	fi
}

fi

EXPORT_FUNCTIONS pkg_nofetch src_unpack pkg_info
