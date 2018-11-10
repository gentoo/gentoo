# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="CQRLOG is an advanced ham radio logger based on MySQL database."
HOMEPAGE="https://www.cqrlog.com/"
SRC_URI="https://github.com/ok2cqr/cqrlog/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=dev-lang/lazarus-1.8.0
		>=dev-lang/fpc-3.0.2"

RDEPEND="${DEPEND}
		virtual/mysql[server]
		dev-libs/atk
		dev-libs/glib
		x11-libs/cairo
		x11-libs/gdk-pixbuf
		x11-libs/gtk+
		x11-libs/libX11
		x11-libs/pango"

LazarusDir=/usr/share/lazarus/

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/${PV}-makefile.patch"
	epatch "${FILESDIR}/${PV}-database-connection-refactoring.patch"
}

pkg_postist() {
	elog "This package optionally supports media-libs/hablib"
	elog "for monitoring radio settings."
}
