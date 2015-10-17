# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib qmake-utils

DESCRIPTION="A simple C++ wrapper over Gilles Vollant's ZIP/UNZIP package"
HOMEPAGE="http://quazip.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ppc ppc64 x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="test qt4 qt5"

REQUIRED_USE="^^ ( qt4 qt5 )"

RDEPEND="
	sys-libs/zlib[minizip]
	qt4? ( dev-qt/qtcore:4 )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		)
	"
DEPEND="${RDEPEND}
	test? (
		qt4? ( dev-qt/qttest:4 )
		qt5? ( dev-qt/qttest:5 )
		)"

S="${WORKDIR}"/${P}

DOCS="NEWS.txt README.txt"
HTML_DOCS=( doc/html/. )

MULTIBUILD_VARIANTS=( qt4 qt5 )

PATCHES=(
	"${FILESDIR}"/${PN}-0.5.1-prll.patch
)

src_prepare() {
	sed \
		-e "s:\/lib/:\/$(get_libdir)\/:g" \
		-i ${PN}/${PN}.pro || die

	echo "PREFIX=${EPREFIX}/usr" >> ${PN}/${PN}.pri || die

	use test || sed -e 's:qztest::g' -i ${PN}.pro || die
}

src_configure() {
	if use qt5; then
		eqmake5
	else
		eqmake4
	fi
}

src_test() {
	cd qztest || die
	LD_LIBRARY_PATH="${S}"/${PN} ./qztest || die
}

src_install() {
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install
	einstalldocs
	insinto /usr/share/cmake/Modules
	doins FindQuaZip.cmake
}
