# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

if [[ ${PV} == *9999 ]]; then
	KMNAME="kdesupport"
fi
KDE_REQUIRED="never"
KDE_SCM="svn"
inherit kde4-base

DESCRIPTION="Oxygen SVG icon theme"
HOMEPAGE="http://www.oxygen-icons.org/"
[[ ${PV} == *9999 ]] || \
SRC_URI="
	!sources? ( https://dev.gentoo.org/~kensington/distfiles/${P}.repacked.tar.xz )
	sources? ( ${SRC_URI} )
"

LICENSE="LGPL-3"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="sources"

DEPEND=""
RDEPEND="${DEPEND}"
