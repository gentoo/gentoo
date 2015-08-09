# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_P=${PN}-${PV/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="core"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="http://download.enlightenment.org/rel/libs/${PN}/${MY_P}.tar.xz"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="Provides external applications as generic loaders for Evas"
HOMEPAGE="http://www.enlightenment.org/"

LICENSE="GPL-2"
# The -arch need to keyword vlc first.
KEYWORDS="~alpha ~amd64 ~arm -hppa -ia64 ~mips ~ppc ~ppc64 ~sh -sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-interix ~x86-solaris ~x64-solaris"

RDEPEND=">=dev-libs/efl-${PV}
	media-video/vlc"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
