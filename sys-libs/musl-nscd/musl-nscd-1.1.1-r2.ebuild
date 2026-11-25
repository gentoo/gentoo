# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd tmpfiles

DESCRIPTION="musl-nscd is an implementation of the NSCD protocol for the musl libc"
HOMEPAGE="https://github.com/pikhq/musl-nscd"
SRC_URI="
	https://github.com/pikhq/musl-nscd/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="
	!sys-libs/glibc
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-alternatives/lex
	sys-devel/bison
"

src_prepare() {
	default

	sed -i '/LDFLAGS_AUTO=-s/d' configure || die
}

src_configure() {
	local -x YACC=bison #863416

	econf
}

src_install() {
	if use minimal; then
		emake DESTDIR="${D}" install-headers
	else
		emake DESTDIR="${D}" install

		newinitd "${FILESDIR}"/nscd.initd nscd
		systemd_dounit "${FILESDIR}"/nscd.service
		newtmpfiles "${FILESDIR}"/nscd.tmpfilesd nscd.conf

		dodoc README
	fi
}

pkg_postinst() {
	use minimal || tmpfiles_process nscd.conf
}
