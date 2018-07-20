# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# @ECLASS: leechcraft.eclass
# @MAINTAINER:
# 0xd34df00d@gmail.com
# @AUTHOR:
# 0xd34df00d@gmail.com
# NightNord@niifaq.ru
# @BLURB: Common functions and setup utilities for the LeechCraft app
# @DESCRIPTION:
# The leechcraft eclass contains a common set of functions and steps
# needed to build LeechCraft core or its plugins.
#
# Though this eclass seems to be small at the moment, it seems like a
# good idea to make all plugins inherit from it, since all plugins
# have mostly the same configuring/build process.
#
# Thanks for original eclass to Andrian Nord <NightNord@niifaq.ru>.
#
# Only EAPI >=6 is supported

case ${EAPI:-0} in
	6) ;;
	*) die "EAPI not supported, bug ebuild mantainer" ;;
esac

inherit cmake-utils

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/0xd34df00d/leechcraft.git"

	inherit git-r3
else
	DEPEND="app-arch/xz-utils"
	SRC_URI="https://dist.leechcraft.org/LeechCraft/${PV}/leechcraft-${PV}.tar.xz"
	S="${WORKDIR}/leechcraft-${PV}"
fi

HOMEPAGE="https://leechcraft.org/"
LICENSE="Boost-1.0"

# @ECLASS-VARIABLE: LEECHCRAFT_PLUGIN_CATEGORY
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this to the category of the plugin, if any.
: ${LEECHCRAFT_PLUGIN_CATEGORY:=}

if [[ "${LEECHCRAFT_PLUGIN_CATEGORY}" ]]; then
	CMAKE_USE_DIR="${S}"/src/plugins/${LEECHCRAFT_PLUGIN_CATEGORY}/${PN#lc-}
elif [[ ${PN} != lc-core ]]; then
	CMAKE_USE_DIR="${S}"/src/plugins/${PN#lc-}
else
	CMAKE_USE_DIR="${S}"/src
fi
