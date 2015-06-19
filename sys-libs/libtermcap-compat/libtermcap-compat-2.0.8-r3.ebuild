# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libtermcap-compat/libtermcap-compat-2.0.8-r3.ebuild,v 1.8 2014/12/07 16:32:16 heroxbd Exp $

# we only want this for binary-only packages, so we will only be installing
# the lib used at runtime; no headers and no files to link against

EAPI="4"

inherit eutils multilib toolchain-funcs

PATCHVER="2"

MY_P="termcap-${PV}"
DESCRIPTION="Compatibility package for old termcap-based programs"
HOMEPAGE="http://www.catb.org/~esr/terminfo/"
SRC_URI="http://www.catb.org/~esr/terminfo/termtypes.tc.gz
	mirror://gentoo/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2 LGPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ppc sparc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_prepare() {
	EPATCH_SOURCE="${WORKDIR}/patch"
	EPATCH_SUFFIX="patch"
	epatch "${EPATCH_SOURCE}"

	cd "${WORKDIR}"
	mv termtypes.tc termcap || die
	epatch "${EPATCH_SOURCE}"/tc.file
}

src_configure() {
	tc-export CC
}

src_install() {
	dolib.so libtermcap.so.${PV}
	dosym libtermcap.so.${PV} /usr/$(get_libdir)/libtermcap.so.2

	insinto /etc
	doins "${WORKDIR}"/termcap

	dodoc ChangeLog README
}
