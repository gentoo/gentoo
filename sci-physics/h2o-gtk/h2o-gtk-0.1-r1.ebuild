# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GTK+ UI for libh2o -- water & steam properties"
HOMEPAGE="https://github.com/mgorny/h2o-gtk/"
SRC_URI="https://github.com/mgorny/h2o-gtk/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4=
	sci-libs/libh2oxx:0=
	sci-libs/plotmm:0="
DEPEND="${RDEPEND}"

src_configure() {
	local -x CXXFLAGS="${CXXFLAGS} -std=c++11"
	default
}
