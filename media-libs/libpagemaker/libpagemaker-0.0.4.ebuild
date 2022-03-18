# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGIT_REPO_URI="git://gerrit.libreoffice.org/${PN}.git"
[[ ${PV} == 9999 ]] && inherit autotools git-r3

DESCRIPTION="C++ Library that parses the file format of Aldus/Adobe PageMaker documents"
HOMEPAGE="https://wiki.documentfoundation.org/DLP/Libraries/libpagemaker"
[[ ${PV} == 9999 ]] || SRC_URI="http://dev-www.libreoffice.org/src/${PN}/${P}.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"

[[ ${PV} == 9999 ]] || \
KEYWORDS="amd64 ~arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
IUSE="debug doc tools"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	dev-libs/boost
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_prepare() {
	default
	[[ ${PV} == 9999 ]] && eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_with doc docs) \
		$(use_enable tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
