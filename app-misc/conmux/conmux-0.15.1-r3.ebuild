# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

DESCRIPTION="A console multiplexor"
HOMEPAGE="https://github.com/autotest/autotest"
SRC_URI="https://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE=""

RDEPEND="dev-perl/IO-Multiplex
	dev-perl/URI"
DEPEND=""

src_prepare() {
	# manual installation of drivers and helpers
	sed -i -e "/include/d" Makefile || die "Failed to fix Makefile"
}

src_install() {
		perl_set_version
		emake BASE="${D}/usr" install
		# helpers and drivers have been removed in src_prepare
		insinto /usr/share/${PN}/
		doins -r drivers/  helpers/
		fperms -R 0750 /usr/share/${PN}/{drivers,helpers}/
		dodir /etc/${PN}
		# no need to have the init script in /sbin
		rm "${D}"/usr/sbin/start || die "failed to remove init script"
		# console is too generic. Make it conmux-console instead
		mv "${D}"/usr/bin/console "${D}"/usr/bin/${PN}-console || \
			die "failed to rename console to conmux-console"
		# Fix up directory for the module
		perl_set_version
		dodir ${VENDOR_LIB}/${PN}
		mv "${D}"/usr/lib/Conmux.pm "${D}"/${VENDOR_LIB}/. || \
			die "failed to move the Conmux.pm module"
		newinitd "${FILESDIR}"/${PN}.initd ${PN}
		newinitd "${FILESDIR}"/${PN}-registry.initd ${PN}-registry
		newconfd "${FILESDIR}"/${PN}.confd ${PN}
		newconfd "${FILESDIR}"/${PN}-registry.confd ${PN}-registry
		dodoc README
}

pkg_postinst() {
	elog ""
	elog "If you have more than one serial ports and you want to use all"
	elog "of them with conmux, copy and paste the 'conmux' init.d and conf.d"
	elog "files as many times as you want, pointing each conf.d file to the"
	elog "device's configuration file."
	elog ""
	elog "See /etc/conf.d/conmux and"
	elog "https://github.com/autotest/autotest/wiki/Conmux-OriginalDocumentation"
	elog "https://github.com/autotest/autotest/wiki/Conmux-Howto"
	elog "for more information"
	elog ""
}
