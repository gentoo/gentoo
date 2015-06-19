# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/mingw-runtime/mingw-runtime-3.16.ebuild,v 1.3 2015/02/27 08:10:52 vapier Exp $

# This version does not work as the configure script expects the installed
# cross-compiler to be able to link binaries ... except we haven't provided
# any of the crt objects yet so it is impossible to link binaries.
# Older mingw-runtime packages hacked around the issue, but this version seems
# to have dropped said hack thus breaking the package.

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

inherit eutils flag-o-matic

MY_P="mingwrt-${PV}-mingw32"
DESCRIPTION="Free Win32 runtime and import library definitions"
HOMEPAGE="http://www.mingw.org/"
SRC_URI="mirror://sourceforge/mingw/${MY_P}-src.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="crosscompile_opts_headers-only"
RESTRICT="strip"

S=${WORKDIR}/${MY_P}

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}
just_headers() {
	use crosscompile_opts_headers-only && [[ ${CHOST} != ${CTARGET} ]]
}

pkg_setup() {
	if [[ ${CBUILD} == ${CHOST} ]] && [[ ${CHOST} == ${CTARGET} ]] ; then
		die "Invalid configuration"
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -i \
		-e "/W32API_INCLUDE/s:=.*:='-I /usr/${CTARGET}/usr/include':" \
		$(find -name configure) || die
	epatch "${FILESDIR}"/${PN}-3.12-DESTDIR.patch
}

src_compile() {
	just_headers && return 0

	CHOST=${CTARGET} strip-unsupported-flags
	econf --host=${CTARGET} || die
	emake || die
}

src_install() {
	if just_headers ; then
		insinto /usr/${CTARGET}/usr/include
		doins -r include/* || die
	else
		local insdir
		is_crosscompile \
			&& insdir="${D}/usr/${CTARGET}" \
			|| insdir="${D}"
		emake install DESTDIR="${insdir}" || die
		env -uRESTRICT CHOST=${CTARGET} prepallstrip
		rm -rf "${insdir}"/usr/doc
		dodoc CONTRIBUTORS ChangeLog README TODO readme.txt
	fi
	is_crosscompile && dosym usr /usr/${CTARGET}/mingw
}
