# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# @ECLASS: sword-module.eclass
# @MAINTAINER:
# Marek Szuba <marecki@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Simplify installation of SWORD modules
# @DESCRIPTION:
# This eclass provides dependencies, ebuild environment and the src_install
# function common to all app-text/sword modules published by the SWORD Project.
#
# Note that as of 2021-06-16 module archives published by SWORD are still
# not versioned and it is necessary to look at respective module pages in
# order to see what versions the currently available files are. Once
# a module file has been replicated to the Gentoo mirror network it will be
# versioned and remain available even after upstream has changed their
# version, however users not using mirrors will encounter hash conflicts
# on updated modules. Should that happen, please notify the relevant
# package maintainers that a new version is available.
#
# @EXAMPLE:
# sword-Personal-1.0.ebuild, a typical ebuild using sword-module.eclass:
#
# @CODE
# EAPI=8
#
# SWORD_MINIMUM_VERSION="1.5.1a"
#
# inherit sword-module
#
# DESCRIPTION="SWORD module for storing one's own commentary"
# HOMEPAGE="https://crosswire.org/sword/modules/ModInfo.jsp?modName=Personal"
# LICENSE="public-domain"
# KEYWORDS="~amd64 ~ppc ~x86"
#
# @CODE

case ${EAPI:-0} in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI} (too old) for ${ECLASS}"
		;;
	7|8)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

# @ECLASS_VARIABLE: SWORD_MINIMUM_VERSION
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set to a non-null value, specifies the minimum version of app-text/sword
# the module requires. This will be included in RDEPEND. If null or unset,
# the dependency will be unversioned.
# Needs to be set before the inherit line.

# @ECLASS_VARIABLE: SWORD_MODULE
# @PRE_INHERIT
# @DESCRIPTION:
# Case-sensitive name of the SWORD-Project module to install. If unset
# or null, use the name produced by removing the prefix 'sword-' from PN.
# Needs to be set before the inherit line.
: ${SWORD_MODULE:=${PN#sword-}}

EXPORT_FUNCTIONS src_install

# Unless overridden at ebuild level, append version to the name of the file
# fetched from upstream and let the Gentoo mirror network take care of
# persisting the versioned archive.
SRC_URI="https://crosswire.org/ftpmirror/pub/sword/packages/rawzip/${SWORD_MODULE}.zip -> ${SWORD_MODULE}-${PV}.zip"

SLOT="0"

# Module archives contain no top-level directory.
S="${WORKDIR}"

if [[ ${SWORD_MINIMUM_VERSION} ]]; then
	RDEPEND=">=app-text/sword-${SWORD_MINIMUM_VERSION}"
else
	RDEPEND="app-text/sword"
fi

BDEPEND="app-arch/unzip"

# @FUNCTION: sword-module_src_install
# @DESCRIPTION:
# Install all the module files into directories used by app-text/sword.
sword-module_src_install() {
	insinto /usr/share/sword/modules
	doins -r modules/*
	insinto /usr/share/sword/mods.d
	doins mods.d/*
}
