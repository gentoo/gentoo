# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A collection of functions, classes and so on, for vdr plugins"
HOMEPAGE="https://github.com/wirbel-at-vdr-portal/librepfunc"
SRC_URI="https://github.com/wirbel-at-vdr-portal/librepfunc/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

PATCHES=(
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/gcc-15-fix.patch"
)

src_install() {
	emake DESTDIR="${D}" libdir="/usr/$(get_libdir)/" pkgconfigdir="/usr/$(get_libdir)/pkgconfig" install
	einstalldocs
}
