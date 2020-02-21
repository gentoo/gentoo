# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=KENTNL
MODULE_VERSION=0.2.12
inherit perl-module eutils prefix

DESCRIPTION="Portage abstraction layer for perl"
HOMEPAGE="http://search.cpan.org/~kentnl/PortageXS"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="minimal"

DEPEND="
	dev-perl/Module-Build
	virtual/perl-Term-ANSIColor
	dev-perl/Shell-EnvImporter
	!minimal? (
		dev-perl/IO-Socket-SSL
		virtual/perl-Sys-Syslog
	)
"

src_prepare() {
	epatch "${FILESDIR}"/0.02.12/${PN}-0.02.12-prefix.patch

	eprefixify \
		lib/PortageXS/examples/getParamFromFile.pl \
		lib/PortageXS/Core.pm \
		lib/PortageXS.pm \
		usr/bin/portagexs_client \
		usr/sbin/portagexsd \
		t/01_Core.t

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

SRC_TEST="do parallel"
