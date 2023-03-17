# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: plasma-mobile.kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: kde.org
# @BLURB: Support eclass for KDE Plasma Mobile packages.
# @DESCRIPTION:
# This eclass extends kde.org.eclass for Plasma Mobile release group to assemble
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

if [[ -z ${_PLASMA_MOBILE_KDE_ORG_ECLASS} ]]; then
_PLASMA_MOBILE_KDE_ORG_ECLASS=1

# @ECLASS_VARIABLE: KDE_ORG_CATEGORY
# @PRE_INHERIT
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
: ${KDE_ORG_CATEGORY:=plasma-mobile}

inherit kde.org

HOMEPAGE="https://plasma-mobile.org/"

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_ORG_SCHEDULE_URI="https://invent.kde.org/plasma/plasma-mobile/-/wikis/Release-Schedule"

if [[ ${KDE_BUILD_TYPE} != live && -z ${KDE_ORG_COMMIT} ]]; then
	SRC_URI="mirror://kde/stable/plasma-mobile/$(ver_cut 1-2)/${KDE_ORG_NAME}-${PV}.tar.xz"
fi

fi
