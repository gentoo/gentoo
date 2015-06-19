# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/dstat/dstat-0.7.2-r1.ebuild,v 1.10 2012/12/16 17:41:47 armin76 Exp $

EAPI=4

PYTHON_DEPEND="2"

inherit python eutils

DESCRIPTION="Versatile replacement for vmstat, iostat and ifstat"
HOMEPAGE="http://dag.wieers.com/home-made/dstat/"
SRC_URI="http://dag.wieers.com/home-made/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
IUSE="wifi"

RDEPEND="wifi? ( net-wireless/python-wifi )"
DEPEND=""

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_compile() {
	true
}

src_install() {
	emake DESTDIR="${ED}" install
	python_convert_shebangs 2 "${ED}usr/bin/dstat"

	dodoc \
		AUTHORS ChangeLog README TODO \
		examples/{mstat,read}.py docs/*.txt
	dohtml docs/*.html
}

pkg_postinst() {
	python_mod_optimize /usr/share/dstat
}

pkg_postrm() {
	python_mod_cleanup /usr/share/dstat
}
