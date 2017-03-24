# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit cmake-multilib

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
# changing sources. Using a revision on the binary in order
# to keep the old one for previous ebuilds.
SRC_URI="https://github.com/openexr/openexr/archive/v${PV}.tar.gz -> openexr-${PV}-r1.tar.gz"

LICENSE="BSD"
SLOT="0/12" # based on SONAME
KEYWORDS="~amd64 -arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"

DOCS=( AUTHORS ChangeLog NEWS README )

MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfig.h )

S="${WORKDIR}/openexr-${PV}/IlmBase"

mycmakeargs=( -DNAMESPACE_VERSIONING=ON )
