# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/newlib/newlib-1.19.0.ebuild,v 1.4 2015/02/27 08:01:12 vapier Exp $

inherit eutils flag-o-matic toolchain-funcs

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION="Newlib is a C library intended for use on embedded systems"
HOMEPAGE="http://sourceware.org/newlib/"
SRC_URI="ftp://sourceware.org/pub/newlib/${P}.tar.gz"

LICENSE="NEWLIB LIBGLOSS GPL-2"
[[ ${CTARGET} != ${CHOST} ]] \
	&& SLOT="${CTARGET}" \
	|| SLOT="0"
KEYWORDS="-* ~arm ~hppa ~m68k ~mips ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="nls threads unicode crosscompile_opts_headers-only"
RESTRICT="strip"

NEWLIBBUILD="${WORKDIR}/build"

pkg_setup() {
	# Reject newlib-on-glibc type installs
	if [[ ${CTARGET} == ${CHOST} ]] ; then
		case ${CHOST} in
			*-newlib|*-elf) ;;
			*) die "Use sys-devel/crossdev to build a newlib toolchain" ;;
		esac
	fi
}

src_unpack() {
	unpack ${A}
	mkdir -p "${NEWLIBBUILD}"
}

src_compile() {
	# we should fix this ...
	unset LDFLAGS
	CHOST=${CTARGET} strip-unsupported-flags

	local myconf=""
	[[ ${CTARGET} == "spu" ]] \
		&& myconf="${myconf} --disable-newlib-multithread" \
		|| myconf="${myconf} $(use_enable threads newlib-multithread)"

	cd "${NEWLIBBUILD}"

	ECONF_SOURCE=${S} \
	econf \
		$(use_enable unicode newlib-mb) \
		$(use_enable nls) \
		${myconf} \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	cd "${NEWLIBBUILD}"
	emake -j1 DESTDIR="${D}" install || die
#	env -uRESTRICT CHOST=${CTARGET} prepallstrip
	# minor hack to keep things clean
	rm -fR "${D}"/usr/share/info
	rm -fR "${D}"/usr/info
}
