# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature toolchain-funcs

DESCRIPTION="Service manager for the s6 supervision suite"
HOMEPAGE="https://www.skarnet.org/software/s6-rc/"
SRC_URI="https://www.skarnet.org/software/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64 arm x86"

RDEPEND="
	dev-lang/execline:=
	>=dev-libs/skalibs-2.14.0.0:=
	>=sys-apps/s6-2.11.3.0:=[execline]
"
DEPEND="${RDEPEND}"

HTML_DOCS=( doc/. )

src_prepare() {
	default

	# Avoid QA warning for LDFLAGS addition
	sed -i -e 's/.*-Wl,--hash-style=both$/:/' configure || die

	sed -i -e '/AR := /d' -e '/RANLIB := /d' Makefile || die
}

src_configure() {
	tc-export AR CC RANLIB

	local myconf=(
		--bindir=/bin
		--dynlibdir="/$(get_libdir)"
		--libdir="/usr/$(get_libdir)/${PN}"
		--libexecdir=/lib/s6
		--with-dynlib="/$(get_libdir)"
		--with-lib="/usr/$(get_libdir)/execline"
		--with-lib="/usr/$(get_libdir)/s6"
		--with-lib="/usr/$(get_libdir)/skalibs"
		--with-sysdeps="/usr/$(get_libdir)/skalibs"
		--enable-shared
		--disable-allstatic
		--disable-static
		--disable-static-libc
	)

	econf "${myconf[@]}"
}

pkg_postinst() {
	for ver in ${REPLACING_VERSIONS}; do
		if ver_test "${ver}" -lt "0.5.4.0"; then
			elog "Location of helper utilities was changed from /usr/libexec to /lib/s6 in"
			elog "version 0.5.4.0. It is necessary to recompile and update s6-rc database and"
			elog "restart s6rc-oneshot-runner service because you are upgrading from older"
			elog "version."
		fi
	done

	optfeature "man pages" app-doc/s6-rc-man-pages
}
