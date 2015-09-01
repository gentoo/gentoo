# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit versionator

MY_DATE="$(get_version_component_range 3)"

DESCRIPTION="Library for providing a basic file input/output abstraction layer"
HOMEPAGE="https://github.com/libyal/libbfio"
SRC_URI="http://dev.pentoo.ch/~zero/distfiles/${PN}-alpha-${MY_DATE}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="unicode"

S="${WORKDIR}/${PN}-${MY_DATE}"

src_configure() {
	econf $(use_enable unicode wide-character-type)
}
