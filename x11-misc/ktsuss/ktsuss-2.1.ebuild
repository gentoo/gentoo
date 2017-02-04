# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Graphical version of su written in C and GTK+ 2"
HOMEPAGE="https://github.com/nomius/ktsuss"
SRC_URI="https://github.com/nomius/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ~ppc64 x86"
IUSE="sudo"

RDEPEND=">=x11-libs/gtk+-2.12.11:2
	>=dev-libs/glib-2.16.5:2
	sudo? ( app-admin/sudo )"
DEPEND="virtual/pkgconfig
	${RDEPEND}"

DOCS=( Changelog CREDITS README.md )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable sudo)
}
