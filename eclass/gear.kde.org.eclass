# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gear.kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: kde.org
# @BLURB: Support eclass for KDE Gear packages.
# @DESCRIPTION:
# This eclass extends kde.org.eclass for KDE Gear release group to assemble
# default SRC_URI for tarballs, set up git-r3.eclass for stable/master branch
# versions or restrict access to unreleased (packager access only) tarballs
# in Gentoo KDE overlay.
#
# This eclass unconditionally inherits kde.org.eclass and all its public
# variables and helper functions (not phase functions) may be considered as
# part of this eclass's API.

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GEAR_KDE_ORG_ECLASS} ]]; then
_GEAR_KDE_ORG_ECLASS=1

# @ECLASS_VARIABLE: KDE_PV_UNRELEASED
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_PV_UNRELEASED=( )

inherit kde.org

HOMEPAGE="https://apps.kde.org/"

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_ORG_SCHEDULE_URI+="/KDE_Gear_${PV:0:5}_Schedule"

# @ECLASS_VARIABLE: _KDE_SRC_URI
# @INTERNAL
# @DESCRIPTION:
# Helper variable to construct release group specific SRC_URI.
_KDE_SRC_URI="mirror://kde/"

if [[ ${KDE_BUILD_TYPE} == live ]]; then
	if [[ ${PV} == ??.??.49.9999 ]]; then
		EGIT_BRANCH="release/$(ver_cut 1-2)"
	fi
elif [[ -z ${KDE_ORG_COMMIT} ]]; then
	case ${PV} in
		??.??.[6-9]? )
			_KDE_SRC_URI+="unstable/release-service/${PV}/src/"
			RESTRICT+=" mirror"
			;;
		*) _KDE_SRC_URI+="stable/release-service/${PV}/src/" ;;
	esac

	SRC_URI="${_KDE_SRC_URI}${KDE_ORG_NAME}-${PV}.tar.xz"
fi

fi
