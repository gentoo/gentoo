# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Library that allows non-privileged apps to write utmp (login) info"
HOMEPAGE="https://git.altlinux.org/people/ldv/packages/?p=libutempter.git https://github.com/altlinux/libutempter"
SRC_URI="ftp://ftp.altlinux.org/pub/people/ldv/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="
	!sys-apps/utempter
	acct-group/utmp
"

src_prepare() {
	default

	local args=(
		-e "/^libdir /s:/usr/lib:${EPREFIX}/usr/$(get_libdir):"
		-e '/^libexecdir /s:=.*:= $(libdir)/misc:'
		-e '/^CFLAGS = $(RPM_OPT_FLAGS)/d'
		-e 's:-Wl,-stats::'
		-e "/^includedir /s:/usr/include:${EPREFIX}/usr/include:"
		-e "/^mandir /s:=.*:= ${EPREFIX}/usr/share/man:"
	)

	if ! use static-libs ; then
		 args+=(
			-e '/^STATICLIB/d'
			-e '/INSTALL.*STATICLIB/d'
		)
	fi

	sed -i "${args[@]}" Makefile || die
}

src_configure() {
	tc-export AR CC
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
	local path
	for path in "${EROOT}"/var/log/{w,u}tmp; do
		chown root:utmp "${path}"
		chmod 664 "${path}"
	done
}
