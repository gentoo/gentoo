# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: plasma.kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: kde.org
# @BLURB: Support eclass for KDE Plasma packages.
# @DESCRIPTION:
# This eclass extends kde.org.eclass for KDE Plasma release group to assemble
# default SRC_URI for tarballs, set up git-r3.eclass for stable/master branch
# versions or restrict access to unreleased (packager access only) tarballs
# in Gentoo KDE overlay.
#
# This eclass unconditionally inherits kde.org.eclass and all its public
# variables and helper functions (not phase functions) may be considered as
# part of this eclass's API.

case ${EAPI} in
	8) ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

if [[ -z ${_PLASMA_KDE_ORG_ECLASS} ]]; then
_PLASMA_KDE_ORG_ECLASS=1

# @ECLASS_VARIABLE: KDE_PV_UNRELEASED
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_PV_UNRELEASED=( )

inherit kde.org

HOMEPAGE="https://kde.org/plasma-desktop"

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_ORG_SCHEDULE_URI+="/Plasma_5"

# @ECLASS_VARIABLE: _KDE_SRC_URI
# @INTERNAL
# @DESCRIPTION:
# Helper variable to construct release group specific SRC_URI.
_KDE_SRC_URI="mirror://kde/"

if [[ ${KDE_BUILD_TYPE} == live ]]; then
	if [[ ${PV} != 9999 ]]; then
		EGIT_BRANCH="Plasma/$(ver_cut 1-2)"
	fi
elif [[ -z ${KDE_ORG_COMMIT} ]]; then
	case ${PV} in
		5.??.[6-9]?* )
			_KDE_SRC_URI+="unstable/plasma/$(ver_cut 1-3)/"
			RESTRICT+=" mirror"
			;;
		*) _KDE_SRC_URI+="stable/plasma/$(ver_cut 1-3)/" ;;
	esac

	SRC_URI="${_KDE_SRC_URI}${KDE_ORG_NAME}-${PV}.tar.xz"
fi

fi
