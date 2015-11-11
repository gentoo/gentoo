# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="git://anongit.gentoo.org/proj/elfix.git"
	inherit git-2
else
	SRC_URI="https://dev.gentoo.org/~blueness/elfix/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ppc64 sparc x86"
fi

DESCRIPTION="A suite of tools to work with ELF objects on Hardened Gentoo"
HOMEPAGE="https://www.gentoo.org/proj/en/hardened/pax-quickstart.xml
	https://dev.gentoo.org/~blueness/elfix/"

LICENSE="GPL-3"
SLOT="0"
IUSE="+ptpax +xtpax"

REQUIRED_USE="|| ( ptpax xtpax )"

# These only work with a properly configured PaX kernel
RESTRICT="test"

DEPEND="~dev-python/pypax-${PV}[ptpax=,xtpax=]
	ptpax? ( dev-libs/elfutils )
	xtpax? ( sys-apps/attr )"

RDEPEND="${DEPEND}"

src_prepare() {
	[[ ${PV} == "9999" ]] && ./autogen.sh
}

src_configure() {
	rm -f "${S}/scripts/setup.py"
	econf --disable-tests \
		$(use_enable ptpax) \
		$(use_enable xtpax)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog INSTALL README THANKS TODO
}
