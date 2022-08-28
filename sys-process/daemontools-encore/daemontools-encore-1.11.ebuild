# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic qmail

DESCRIPTION="Collection of tools for managing UNIX services"
HOMEPAGE="https://untroubled.org/daemontools-encore/"
SRC_URI="https://untroubled.org/daemontools-encore/${P}.tar.gz"

LICENSE="GPL-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~loong ~x86"
IUSE="selinux static"

DEPEND=""
RDEPEND="selinux? ( sec-policy/selinux-daemontools )
	!sys-process/daemontools
	!app-doc/daemontools-man"

PATCHES=(
	"${FILESDIR}"/${PN}-1.11-do-not-always-run-tests.patch
	"${FILESDIR}"/${PN}-1.11-add-missing-setuser-man-page.patch
)

src_compile() {
	use static && append-ldflags -static
	qmail_set_cc
	emake
}

src_install() {
	keepdir /service

	echo "${ED%/}/usr/bin" >conf-bin
	echo "${ED%/}/usr/share/man" >conf-man
	dodir /usr/bin
	dodir /usr/share/man
	emake install

	dodoc ChangeLog CHANGES CHANGES.djb README TODO

	newinitd "${FILESDIR}"/svscan.init-2 svscan
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
