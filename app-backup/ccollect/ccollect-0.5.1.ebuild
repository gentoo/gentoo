# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="(pseudo) incremental backup with different exclude lists using
hardlinks and rsync"
HOMEPAGE="http://unix.schottelius.org/ccollect/"
SRC_URI="http://unix.schottelius.org/ccollect/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86"
IUSE="doc"

DEPEND="doc? ( >=app-text/asciidoc-7.0.2 )"
RDEPEND="net-misc/rsync"

src_compile() {
	if use doc; then
		make documentation
	else
		einfo 'Nothing to compile'
	fi
}

src_install() {
	dobin ccollect.sh

	insinto /usr/share/${PN}/tools
	doins tools/*

	if use doc; then
		dodoc doc/*

		# dodoc is not recursive. So do a workaround.
		insinto /usr/share/doc/${PF}/examples/
		doins -r "${S}"/conf
	fi
}

pkg_postinst() {
	ewarn "If you're upgrading from 0.3.X or less, please run"
	ewarn "/usr/share/ccollect/tools/config-pre-0.4-to-0.4.sh"
	ewarn "because the old configuration is no longer compatible."
}
