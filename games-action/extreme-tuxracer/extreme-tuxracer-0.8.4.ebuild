# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop xdg

DESCRIPTION="High speed arctic racing game based on Tux Racer"
HOMEPAGE="https://sourceforge.net/p/extremetuxracer/wiki/Home/"
SRC_URI="https://download.sourceforge.net/extremetuxracer/etr-${PV}.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}/etr-${PV/_/}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	>=media-libs/libsfml-2.4:0=
	virtual/glu
	virtual/opengl
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	# kind of ugly in there so we'll do it ourselves
	sed -i -e '/SUBDIRS/s/resources doc//' Makefile.am || die
	eautoreconf
}

src_install() {
	default
	dodoc doc/{code,courses_events,guide,score_algorithm}
	doicon -s 64 resources/etr.png
	doicon -s scalable resources/etr.svg
	domenu resources/net.sourceforge.extremetuxracer.desktop
}
