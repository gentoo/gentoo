# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit qmake-utils

DESCRIPTION="Note manager"
HOMEPAGE="https://github.com/sialan-labs/kaqaz/"
SRC_URI="https://github.com/sialan-labs/kaqaz/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtmultimedia:5[qml]
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtpositioning:5
	dev-qt/qtsingleapplication[X]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}
	dev-qt/qtgraphicaleffects:5
	dev-qt/qtquickcontrols:5
"

PATCHES=(
	"${FILESDIR}/${P}-qt55.patch"
	"${FILESDIR}/${P}-unbundle-qtsingleapplication.patch"
)

src_prepare() {
	default
	rm -r sialantools/qtsingleapplication || die
}

src_configure() {
	eqmake5
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
