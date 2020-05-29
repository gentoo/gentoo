# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit qmake-utils

DESCRIPTION="./configure like generator for qmake-based projects"
HOMEPAGE="https://github.com/psi-im/qconf"
SRC_URI="https://github.com/psi-im/qconf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ppc64 ~sparc ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtxml:5
"
RDEPEND="${DEPEND}"

src_configure() {
	# not autotools configure, so don't use econf
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
