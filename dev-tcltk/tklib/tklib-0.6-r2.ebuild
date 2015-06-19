# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tklib/tklib-0.6-r2.ebuild,v 1.1 2015/05/06 06:55:44 jlec Exp $

EAPI=5

inherit multilib

CODE=6a397dec6188148cf6a6fe290cf2bd92a9190c42

DESCRIPTION="Collection of utility modules for Tk, and a companion to Tcllib"
HOMEPAGE="http://www.tcl.tk/software/tklib"
SRC_URI="http://core.tcl.tk/tklib/raw/tklib-0.6.tar.bz2?name=${CODE} -> ${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD"
IUSE="doc"

RDEPEND="
	dev-lang/tk:0
	dev-tcltk/tcllib"
DEPEND="${RDEPEND}"

src_install() {
	default
	if use doc; then
		emake DESTDIR="${D}" doc
		dohtml doc/html/*
	fi
	dodoc DESCRIPTION.txt README*
	dosym ${PN}${PV} /usr/$(get_libdir)/${PN}

	mv "${ED}"/usr/share/man/mann/datefield{,-${PN}}.n || die
	mv "${ED}"/usr/share/man/mann/menubar{,-${PN}}.n || die
	mv "${ED}"/usr/bin/dia{,-${PN}} || die
}
