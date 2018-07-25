# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools-utils flag-o-matic

DESCRIPTION="GTK+ UI for libh2o -- water & steam properties"
HOMEPAGE="https://github.com/mgorny/h2o-gtk/"
SRC_URI="https://github.com/mgorny/h2o-gtk/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4=
	>=sci-libs/libh2oxx-0.2
	sci-libs/plotmm"
DEPEND="${RDEPEND}"

src_prepare() {
	autotools-utils_src_prepare
	append-cxxflags -std=c++11
}
