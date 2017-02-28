# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_VERSION=0.02.10
inherit perl-module eutils prefix

DESCRIPTION="Portage abstraction layer for perl"
HOMEPAGE="http://download.mpsna.de/opensource/PortageXS/"
SRC_URI="http://download.mpsna.de/opensource/PortageXS/${PN}-${MODULE_VERSION}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="minimal"
SRC_TEST="do"

DEPEND="
	virtual/perl-Term-ANSIColor
	dev-perl/Shell-EnvImporter
	!minimal? (
		dev-perl/IO-Socket-SSL
		virtual/perl-Sys-Syslog
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.02.10-portage_path_fix.patch
	epatch "${FILESDIR}"/${PN}-0.02.10-prefix.patch

	eprefixify \
		lib/PortageXS/Core.pm \
		lib/PortageXS.pm \
		usr/bin/portagexs_client \
		usr/sbin/portagexsd

	if use minimal ; then
		rm -r "${S}"/usr || die
		rm -r "${S}"/etc/init.d || die
		rm -r "${S}"/etc/pxs/certs || die
		rm "${S}"/etc/pxs/portagexsd.conf || die
		rm -r "${S}"/lib/PortageXS/examples || die
	fi
}

src_install() {
	perl-module_src_install
	if use !minimal ; then
		cp -r "${S}"/usr "${D}${EPREFIX}" || die
	fi
	cp -r "${S}"/etc "${D}${EPREFIX}" || die
}

pkg_postinst() {
	if [ -d "${EPREFIX}"/etc/portagexs ]; then
		elog "${EPREFIX}/etc/portagexs has been moved to ${EPREFIX}/etc/pxs for convenience.  It is safe"
		elog "to delete old ${EPREFIX}/etc/portagexs directories."
	fi
}
