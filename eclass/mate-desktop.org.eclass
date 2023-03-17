# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: mate-desktop.org.eclass
# @MAINTAINER:
# mate@gentoo.org
# @AUTHOR:
# Authors: NP-Hardass <NP-Hardass@gentoo.org> based upon the gnome.org eclass.
# @SUPPORTED_EAPIS: 7
# @BLURB: Helper eclass for mate-desktop.org hosted archives
# @DESCRIPTION:
# Provide a default SRC_URI and EGIT_REPO_URI for MATE packages as well as
# exporting some useful values like the MATE_BRANCH

case ${EAPI} in
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_MATE_DESKTOP_ORG_ECLASS} ]]; then
_MATE_DESKTOP_ORG_ECLASS=1

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
fi

# @ECLASS_VARIABLE: MATE_TARBALL_SUFFIX
# @INTERNAL
# @DESCRIPTION:
# All projects hosted on mate-desktop.org provide tarballs as tar.xz.
# Undefined in live ebuilds.
[[ ${PV} != 9999 ]] && : ${MATE_TARBALL_SUFFIX:="xz"}

# @ECLASS_VARIABLE: MATE_DESKTOP_ORG_PN
# @DESCRIPTION:
# Name of the package as hosted on mate-desktop.org.
# Leave unset if package name matches PN.
: ${MATE_DESKTOP_ORG_PN:=${PN}}

# @ECLASS_VARIABLE: MATE_DESKTOP_ORG_PV
# @DESCRIPTION:
# Package version string as listed on mate-desktop.org.
# Leave unset if package version string matches PV.
: ${MATE_DESKTOP_ORG_PV:=${PV}}

# @ECLASS_VARIABLE: MATE_BRANCH
# @DESCRIPTION:
# Major and minor numbers of the version number, unless live.
# If live ebuild, will be set to '9999'.
: ${MATE_BRANCH:=$(ver_cut 1-2)}

# Set SRC_URI or EGIT_REPO_URI based on whether live
if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/mate-desktop/${MATE_DESKTOP_ORG_PN}.git"
	SRC_URI=""
else
	SRC_URI="https://pub.mate-desktop.org/releases/${MATE_BRANCH}/${MATE_DESKTOP_ORG_PN}-${MATE_DESKTOP_ORG_PV}.tar.${MATE_TARBALL_SUFFIX}"
fi

# Set HOMEPAGE for all ebuilds
HOMEPAGE="https://mate-desktop.org"

fi
