# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# This version is just for the ABI .5 library

EAPI="5"

inherit eutils multilib-minimal flag-o-matic

# Official patches
# See ftp://ftp.cwru.edu/pub/bash/readline-5.1-patches/
PLEVEL=${PV##*_p}
MY_PV=${PV/_p*}
MY_P=${PN}-${MY_PV}
[[ ${PV} != *_p* ]] && PLEVEL=0
patches() {
	[[ ${PLEVEL} -eq 0 ]] && return 1
	local opt=$1
	eval set -- {1..${PLEVEL}}
	set -- $(printf "${PN}${MY_PV/\.}-%03d " "$@")
	if [[ ${opt} == -s ]] ; then
		echo "${@/#/${DISTDIR}/}"
	else
		local u
		for u in ftp://ftp.cwru.edu/pub/bash mirror://gnu/${PN} ; do
			printf "${u}/${PN}-${MY_PV}-patches/%s " "$@"
		done
	fi
}

DESCRIPTION="Another cute console display library"
HOMEPAGE="http://cnswww.cns.cwru.edu/php/chet/readline/rltop.html"
SRC_URI="mirror://gnu/${PN}/${MY_P}.tar.gz $(patches)"

LICENSE="GPL-2"
SLOT="${PV:0:1}"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.2-r2:0[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	[[ ${PLEVEL} -gt 0 ]] && epatch $(patches -s)
	epatch "${FILESDIR}"/${PN}-5.0-no_rpath.patch
	# force ncurses linking #71420
	sed -i -e 's:^SHLIB_LIBS=:SHLIB_LIBS=-lncurses:' support/shobj-conf || die "sed"
}

multilib_src_configure() {
	append-cppflags -D_GNU_SOURCE
	ECONF_SOURCE=${S} \
	econf --with-curses --disable-static
}

multilib_src_compile() {
	emake -C shlib
}

multilib_src_install() {
	emake -C shlib DESTDIR="${D}" install
	rm -f "${D}"/usr/lib*/*.so
}
