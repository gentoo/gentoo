# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: frameworks.kde.org.eclass
# @MAINTAINER:
# kde@gentoo.org
# @SUPPORTED_EAPIS: 8
# @PROVIDES: kde.org
# @BLURB: Support eclass for KDE Frameworks packages.
# @DESCRIPTION:
# This eclass extends kde.org.eclass for Frameworks release group to assemble
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

if [[ -z ${_FRAMEWORKS_KDE_ORG_ECLASS} ]]; then
_FRAMEWORKS_KDE_ORG_ECLASS=1

# @ECLASS_VARIABLE: KDE_PV_UNRELEASED
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_PV_UNRELEASED=( )

inherit kde.org

HOMEPAGE="https://develop.kde.org/products/frameworks/"

SLOT=6
if ver_test ${PV} -lt 5.240; then
	SLOT=5
fi
if [[ ${PN} == extra-cmake-modules ]]; then
	SLOT=0
else
	if [[ ${KDE_BUILD_TYPE} == release ]]; then
		SLOT=${SLOT}/$(ver_cut 1-2)
	else
		SLOT=${SLOT}/9999
	fi
fi

# @ECLASS_VARIABLE: KDE_ORG_SCHEDULE_URI
# @INTERNAL
# @DESCRIPTION:
# For proper description see kde.org.eclass manpage.
KDE_ORG_SCHEDULE_URI+="/Frameworks"

# @ECLASS_VARIABLE: _KDE_SRC_URI
# @INTERNAL
# @DESCRIPTION:
# Helper variable to construct release group specific SRC_URI.
_KDE_SRC_URI="mirror://kde/"

case ${KDE_BUILD_TYPE} in
	live)
		if [[ ${PV} == 5.239.9999 ]]; then
			EGIT_BRANCH="kf5"
		fi
		;;
	*)
		if [[ -z ${KDE_ORG_COMMIT} ]]; then
			_KDE_SRC_URI+="stable/frameworks/$(ver_cut 1-2)/"
			case ${KDE_ORG_NAME} in
				kdelibs4support | \
				kdesignerplugin | \
				kdewebkit | \
				khtml | \
				kjs | \
				kjsembed | \
				kmediaplayer | \
				kross | \
				kxmlrpcclient)
					_KDE_SRC_URI+="portingAids/"
					;;
			esac

			SRC_URI="${_KDE_SRC_URI}${KDE_ORG_TAR_PN}-${PV}.tar.xz"
		fi
		;;
esac

fi
