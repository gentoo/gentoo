# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/glu/glu-9.0.0-r1.ebuild,v 1.13 2015/03/03 08:27:34 dlan Exp $

EAPI=5

EGIT_REPO_URI="git://anongit.freedesktop.org/mesa/glu"

if [[ ${PV} = 9999* ]]; then
	AUTOTOOLS_AUTORECONF=1
	GIT_ECLASS="git-2"
	EXPERIMENTAL="true"
fi

inherit autotools-multilib multilib ${GIT_ECLASS}

DESCRIPTION="The OpenGL Utility Library"
HOMEPAGE="http://cgit.freedesktop.org/mesa/glu/"

if [[ ${PV} = 9999* ]]; then
	SRC_URI=""
else
	SRC_URI="ftp://ftp.freedesktop.org/pub/mesa/${PN}/${P}.tar.bz2"
fi

LICENSE="SGI-B-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

DEPEND=">=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}
	!<media-libs/mesa-9
	abi_x86_32? ( !app-emulation/emul-linux-x86-opengl[-abi_x86_32(-)] )"

src_unpack() {
	default
	[[ $PV = 9999* ]] && git-2_src_unpack
}

src_test() {
	:;
}
