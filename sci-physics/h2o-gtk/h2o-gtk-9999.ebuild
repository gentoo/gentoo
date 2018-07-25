# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3

DESCRIPTION="GTK+ UI for libh2o -- water & steam properties"
HOMEPAGE="https://github.com/mgorny/h2o-gtk/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/h2o-gtk.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4=
	sci-libs/libh2oxx:0=
	sci-libs/plotmm:0="
DEPEND="${RDEPEND}"

src_prepare() {
	default
	eautoreconf
}
