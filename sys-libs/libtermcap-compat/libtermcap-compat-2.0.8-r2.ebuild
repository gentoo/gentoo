# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# we only want this for binary-only packages, so we will only be installing
# the lib used at runtime; no headers and no files to link against

inherit eutils multilib

PATCHVER=1

MY_P="termcap-${PV}"
DESCRIPTION="Compatibility package for old termcap-based programs"
HOMEPAGE="http://www.catb.org/~esr/terminfo/"
SRC_URI="http://www.catb.org/~esr/terminfo/termtypes.tc.gz
	mirror://gentoo/${MY_P}.tar.bz2
	mirror://gentoo/${MY_P}-patches-${PATCHVER}.tar.bz2"

LICENSE="GPL-2 LGPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}

	EPATCH_SOURCE="${WORKDIR}/patch"
	EPATCH_SUFFIX="patch"

	cd "${WORKDIR}"
	mv termtypes.tc termcap || die
	epatch "${EPATCH_SOURCE}"/tc.file

	cd "${S}"
	epatch "${EPATCH_SOURCE}"
}

src_compile() {
	emake prefix="/" CFLAGS="${CFLAGS} -I." || die
}

src_install() {
	dodir /lib /include
	emake prefix="${D}" OWNER="root:root" install || die
	dodoc ChangeLog README

	insinto /etc
	doins "${WORKDIR}"/termcap

	# now punt everything used for compiling
	cd "${D}"
	rm -r include || die

	if [[ $(get_libdir) != "lib" ]] ; then
		mv lib $(get_libdir) || die
	fi
	dosym libtermcap.so.${PV} /$(get_libdir)/libtermcap.so.2
	cd $(get_libdir)
	rm -f libtermcap.{a,so}
}
