# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit qmake-utils

DESCRIPTION="./configure like generator for qmake-based projects"
HOMEPAGE="https://github.com/psi-plus/qconf"
SRC_URI="http://psi-im.org/files/qconf/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtxml:5
"
DEPEND="${RDEPEND}"

src_configure() {
	# not autotools configure. generates warnings for some autotools params.
	./configure \
		--prefix="${EPREFIX}"/usr \
		--qtdir="$(qt5_get_libdir)/qt5" \
		--extraconf=QMAKE_STRIP= \
		--verbose || die "configure failed"

	# just to set all the Gentoo toolchain flags
	eqmake5
}

src_install() {
	emake INSTALL_ROOT="${D}" install
	einstalldocs
	dodoc -r examples
}
