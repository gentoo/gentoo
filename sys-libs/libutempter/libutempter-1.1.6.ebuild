# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-libs/libutempter/libutempter-1.1.6.ebuild,v 1.1 2012/08/28 06:51:59 radhermit Exp $

EAPI="4"

inherit user multilib flag-o-matic

DESCRIPTION="Library that allows non-privileged apps to write utmp (login) info, which need root access"
HOMEPAGE="http://altlinux.org/index.php?module=sisyphus&package=libutempter"
SRC_URI="ftp://ftp.altlinux.org/pub/people/ldv/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs elibc_FreeBSD"

RDEPEND="!sys-apps/utempter"

pkg_setup() {
	enewgroup utmp 406
}

src_prepare() {
	local args=(
		-e "/^libdir /s:/lib:/$(get_libdir):"
		-e '/^libexecdir /s:=.*:= $(libdir)/misc:'
		-e '/^CFLAGS = $(RPM_OPT_FLAGS)/d'
		-e 's:,-stats::'
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

	fowners root:utmp /usr/$(get_libdir)/misc/utempter/utempter
	fperms 2755 /usr/$(get_libdir)/misc/utempter/utempter
	dodir /usr/sbin
	dosym ../$(get_libdir)/misc/utempter/utempter /usr/sbin/utempter
}

pkg_postinst() {
	if [ -f "${ROOT}/var/log/wtmp" ] ; then
		chown root:utmp "${ROOT}/var/log/wtmp"
		chmod 664 "${ROOT}/var/log/wtmp"
	fi

	if [ -f "${ROOT}/var/run/utmp" ] ; then
		chown root:utmp "${ROOT}/var/run/utmp"
		chmod 664 "${ROOT}/var/run/utmp"
	fi
}
