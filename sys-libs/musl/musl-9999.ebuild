# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic multilib toolchain-funcs
if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://git.musl-libc.org/musl"
	inherit git-r3
	SRC_URI="
	https://dev.gentoo.org/~blueness/musl-misc/getconf.c
	https://dev.gentoo.org/~blueness/musl-misc/getent.c
	https://dev.gentoo.org/~blueness/musl-misc/iconv.c"
	KEYWORDS=""
else
	SRC_URI="http://www.musl-libc.org/releases/${P}.tar.gz
	https://dev.gentoo.org/~blueness/musl-misc/getconf.c
	https://dev.gentoo.org/~blueness/musl-misc/getent.c
	https://dev.gentoo.org/~blueness/musl-misc/iconv.c"
	KEYWORDS="-* ~amd64 ~arm ~mips ~ppc ~x86"
fi

export CBUILD=${CBUILD:-${CHOST}}
export CTARGET=${CTARGET:-${CHOST}}
if [[ ${CTARGET} == ${CHOST} ]] ; then
	if [[ ${CATEGORY} == cross-* ]] ; then
		export CTARGET=${CATEGORY#cross-}
	fi
fi

DESCRIPTION="Light, fast and simple C library focused on standards-conformance and safety"
HOMEPAGE="http://www.musl-libc.org/"
LICENSE="MIT LGPL-2 GPL-2"
SLOT="0"
IUSE="headers-only"

QA_SONAME="/usr/lib/libc.so"
QA_DT_NEEDED="/usr/lib/libc.so"

is_crosscompile() {
	[[ ${CHOST} != ${CTARGET} ]]
}

just_headers() {
	use headers-only && is_crosscompile
}

pkg_setup() {
	if [ ${CTARGET} == ${CHOST} ] ; then
		case ${CHOST} in
		*-musl*) ;;
		*) die "Use sys-devel/crossdev to build a musl toolchain" ;;
		esac
	fi
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
		--disable-gcc-wrapper || die
}

src_compile() {
	emake obj/include/bits/alltypes.h
	just_headers && return 0

	emake
	if [[ ${CATEGORY} != cross-* ]] ; then
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/getconf.c -o "${T}"/getconf || die
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/getent.c -o "${T}"/getent || die
		$(tc-getCC) ${CFLAGS} "${DISTDIR}"/iconv.c -o "${T}"/iconv || die
	fi
}

src_install() {
	local target="install"
	just_headers && target="install-headers"
	emake DESTDIR="${D}" ${target}
	just_headers && return 0

	# musl provides ldd via a sym link to its ld.so
	local sysroot
	is_crosscompile && sysroot=/usr/${CTARGET}
	local ldso=$(basename "${D}"${sysroot}/lib/ld-musl-*)
	dosym ${sysroot}/lib/${ldso} ${sysroot}/usr/bin/ldd

	if [[ ${CATEGORY} != cross-* ]] ; then
		local arch=$("${D}"usr/lib/libc.so 2>&1 | sed -n '1s/^musl libc (\(.*\))$/\1/p')
		[[ -e "${D}"/lib/ld-musl-${arch}.so.1 ]] || die
		cp "${FILESDIR}"/ldconfig.in "${T}" || die
		sed -e "s|@@ARCH@@|${arch}|" "${T}"/ldconfig.in > "${T}"/ldconfig || die
		into /
		dosbin "${T}"/ldconfig
		into /usr
		dobin "${T}"/getconf
		dobin "${T}"/getent
		dobin "${T}"/iconv
		echo 'LDPATH="include ld.so.conf.d/*.conf"' > "${T}"/00musl || die
		doenvd "${T}"/00musl || die
	fi
}

pkg_postinst() {
	is_crosscompile && return 0

	[ "${ROOT}" != "/" ] && return 0

	ldconfig || die
	# reload init ...
	/sbin/telinit U 2>/dev/null
}
