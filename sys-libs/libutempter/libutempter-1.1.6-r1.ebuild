# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit user multilib flag-o-matic

DESCRIPTION="Library that allows non-privileged apps to write utmp (login) info, which need root access"
HOMEPAGE="http://altlinux.org/index.php?module=sisyphus&package=libutempter"
SRC_URI="ftp://ftp.altlinux.org/pub/people/ldv/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux"
IUSE="static-libs elibc_FreeBSD"

RDEPEND="!sys-apps/utempter"

pkg_setup() {
	enewgroup utmp 406
}

src_prepare() {
	local args=(
		-e "/^libdir /s:/usr/lib:${EPREFIX}/usr/$(get_libdir):"
		-e '/^libexecdir /s:=.*:= $(libdir)/misc:'
		-e '/^CFLAGS = $(RPM_OPT_FLAGS)/d'
		-e 's:,-stats::'
		-e "/^includedir /s:/usr/include:${EPREFIX}/usr/include:"
		-e "/^mandir /s:=.*:= ${EPREFIX}/usr/share/man:"
	)
	use static-libs || args+=(
			-e '/^STATICLIB/d'
			-e '/INSTALL.*STATICLIB/d'
		)
	sed -i "${args[@]}" Makefile || die
}

src_configure() {
	use elibc_FreeBSD && append-libs -lutil
	tc-export CC
}

src_compile() {
	emake LDLIBS="${LIBS}"
}

src_install() {
	default

	if ! use prefix ; then
		fowners root:utmp /usr/$(get_libdir)/misc/utempter/utempter
		fperms 2755 /usr/$(get_libdir)/misc/utempter/utempter
	fi
	dodir /usr/sbin
	dosym ../$(get_libdir)/misc/utempter/utempter /usr/sbin/utempter
}

pkg_postinst() {
	if [ -f "${EROOT}/var/log/wtmp" ] ; then
		chown root:utmp "${EROOT}/var/log/wtmp"
		chmod 664 "${EROOT}/var/log/wtmp"
	fi

	if [ -f "${EROOT}/var/run/utmp" ] ; then
		chown root:utmp "${EROOT}/var/run/utmp"
		chmod 664 "${EROOT}/var/run/utmp"
	fi
}
