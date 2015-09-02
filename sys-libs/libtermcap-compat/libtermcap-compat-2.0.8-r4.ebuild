# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# we only want this for binary-only packages, so we will only be installing
# the lib used at runtime; no headers and no files to link against

EAPI="5"

inherit eutils multilib toolchain-funcs multilib-minimal

PATCHVER="2"

MY_P="termcap-${PV}"
DESCRIPTION="Compatibility package for old termcap-based programs"
HOMEPAGE="http://www.catb.org/~esr/terminfo/"
SRC_URI="http://www.catb.org/~esr/terminfo/termtypes.tc.gz
	mirror://gentoo/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2 LGPL-2 BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~sparc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/patch"
	EPATCH_SUFFIX="patch"
	epatch "${EPATCH_SOURCE}"

	cd "${WORKDIR}"
	mv termtypes.tc termcap || die
	epatch "${EPATCH_SOURCE}"/tc.file

	multilib_copy_sources
}

src_configure() {
	tc-export CC
}

multilib_src_install() {
	dolib.so libtermcap.so.${PV}
	dosym libtermcap.so.${PV} /usr/$(get_libdir)/libtermcap.so.2
}

multilib_src_install_all() {
	insinto /etc
	doins "${WORKDIR}"/termcap

	dodoc ChangeLog README
}
