# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="https://cr.yp.to/daemontools.html"
SRC_URI="
	https://cr.yp.to/daemontools/${P}.tar.gz
	https://smarden.org/pape/djb/manpages/${P}-man-20020131.tar.gz"
S="${WORKDIR}/admin/${P}/src"

LICENSE="public-domain GPL-2"	# GPL-2 for init script
SLOT="0"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc ~x86"
IUSE="selinux static"

RDEPEND="selinux? ( sec-policy/selinux-daemontools )"

PATCHES=(
	"${FILESDIR}"/${PV}-errno.patch
	"${FILESDIR}"/${PV}-C99-decls.patch
	"${FILESDIR}"/${PV}-makefile.patch
	"${FILESDIR}"/${PV}-implicit-func-decl-clang16.patch
	"${FILESDIR}"/${PV}-const-typecasts-C99.patch
)

src_configure() {
	tc-export AR CC
	use static && append-ldflags -static

	touch home || die
}

src_install() {
	keepdir /service

	dobin $(<../package/commands)
	dodoc CHANGES ../package/README TODO
	doman "${WORKDIR}"/${PN}-man/*.8

	newinitd "${FILESDIR}"/svscan.init-0.76-r7 svscan
}

pkg_postinst() {
	einfo
	einfo "You can run daemontools using the svscan init.d script,"
	einfo "or you could run it through inittab."
	einfo "To use inittab, emerge supervise-scripts and run:"
	einfo "svscan-add-to-inittab"
	einfo "Then you can hup init with the command telinit q"
	einfo
}
