# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/musl/musl-1.1.8-r2.ebuild,v 1.2 2015/05/13 12:51:20 blueness Exp $

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.musl-libc.org/musl"
	inherit git-2
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION="Lightweight, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"
if [[ ${PV} != "9999" ]] ; then
	PATCH_VER=""
	SRC_URI="http://www.musl-libc.org/releases/${P}.tar.gz"
	KEYWORDS="-* amd64 arm ~mips ppc x86"
fi

LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="crosscompile_opts_headers-only"

RDEPEND="!sys-apps/getent"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

just_headers() {
	use crosscompile_opts_headers-only && is_crosscompile
}

pkg_setup() {
	if [ ${CTARGET} == ${CHOST} ] ; then
		case ${CHOST} in
		*-musl*) ;;
		*) die "Use sys-devel/crossdev to build a musl toolchain" ;;
		esac
	fi

	epatch_user
}

src_configure() {
	tc-getCC ${CTARGET}
	just_headers && export CC=true

	local sysroot
	is_crosscompile && sysroot=/usr/${CTARGET}
	./configure \
		--target=${CTARGET} \
		--prefix=${sysroot}/usr \
		--syslibdir=${sysroot}/lib \
		--disable-gcc-wrapper
}

src_compile() {
	emake include/bits/alltypes.h || die
	just_headers && return 0

	emake || die
}

src_install() {
	local target="install"
	just_headers && target="install-headers"
	emake DESTDIR="${D}" ${target} || die
	just_headers && return 0

	# musl provides ldd via a sym link to its ld.so
	local sysroot
	is_crosscompile && sysroot=/usr/${CTARGET}
	local ldso=$(basename "${D}"${sysroot}/lib/ld-musl-*)
	dosym ${sysroot}/lib/${ldso} ${sysroot}/usr/bin/ldd

	if [[ ${CATEGORY} != cross-* ]] ; then
		into /usr
		dobin "${FILESDIR}"/getent
		into /
		dosbin "${FILESDIR}"/ldconfig
		echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00musl
		doenvd "${T}"/00musl || die
	fi
}

pkg_postinst() {
	is_crosscompile && return 0

	[ "${ROOT}" != "/" ] && return 0

	ldconfig
	# reload init ...
	/sbin/telinit U 2>/dev/null
}
