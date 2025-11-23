# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: gnome.org.eclass
# @MAINTAINER:
# gnome@gentoo.org
# @AUTHOR:
# Authors: Spidler <spidler@gentoo.org> with help of carparski.
# eclass variable additions and documentation: Gilles Dartiguelongue <eva@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Helper eclass for gnome.org hosted archives
# @DESCRIPTION:
# Provide a default SRC_URI for tarball hosted on gnome.org mirrors.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_GNOME_ORG_ECLASS} ]] ; then
_GNOME_ORG_ECLASS=1

# @ECLASS_VARIABLE: GNOME_TARBALL_SUFFIX
# @PRE_INHERIT
# @DESCRIPTION:
# Most projects hosted on gnome.org mirrors provide tarballs as tar.bz2 or
# tar.xz. This eclass defaults to xz. This is because the GNOME mirrors are
# moving to only have xz tarballs for new releases.
: "${GNOME_TARBALL_SUFFIX:="xz"}"

# Even though xz-utils are in @system, they must still be added to BDEPEND; see
# https://archives.gentoo.org/gentoo-dev/msg_a0d4833eb314d1be5d5802a3b710e0a4.xml
[[ ${GNOME_TARBALL_SUFFIX} == "xz" ]] && BDEPEND="app-arch/xz-utils"

# @ECLASS_VARIABLE: GNOME_ORG_MODULE
# @DESCRIPTION:
# Name of the module as hosted on gnome.org mirrors.
# Leave unset if package name matches module name.
: "${GNOME_ORG_MODULE:=${PN}}"

# @ECLASS_VARIABLE: GNOME_ORG_RELEASE
# @INTERNAL
# @DESCRIPTION:
# Components of the version number that correspond to a 6 month release.
if ver_test -ge 40.0; then
	: "${GNOME_ORG_RELEASE:=$(ver_cut 1)}"
else
	: "${GNOME_ORG_RELEASE:=$(ver_cut 1-2)}"
fi

# @ECLASS_VARIABLE: GNOME_ORG_PV
# @DESCRIPTION:
# PV in the GNOME version scheme format.
# The package version in the format used upstream by GNOME projects.
# See https://discourse.gnome.org/t/new-gnome-versioning-scheme/4235
: "${GNOME_ORG_PV:=$(ver_rs 1- .)}"

SRC_URI="mirror://gnome/sources/${GNOME_ORG_MODULE}/${GNOME_ORG_RELEASE}/${GNOME_ORG_MODULE}-${GNOME_ORG_PV}.tar.${GNOME_TARBALL_SUFFIX}"

S="${WORKDIR}/${GNOME_ORG_MODULE}-${GNOME_ORG_PV}"

fi
