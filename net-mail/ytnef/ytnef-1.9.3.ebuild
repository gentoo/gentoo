# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Yeraze's TNEF Stream Reader - for winmail.dat files"
HOMEPAGE="https://github.com/Yeraze/ytnef"
SRC_URI="https://github.com/Yeraze/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~sparc x86"
IUSE="static-libs"

DEPEND="sys-devel/libtool"
RDEPEND="dev-perl/MIME-tools"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
