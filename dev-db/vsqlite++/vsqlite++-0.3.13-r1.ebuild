# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="VSQLite++ - A well designed and portable SQLite3 Wrapper for C++"
HOMEPAGE="http://evilissimo.fedorapeople.org/releases/vsqlite--/"
SRC_URI="https://github.com/vinzenz/vsqlite--/archive/${PV}.tar.gz -> ${P}.tar.gz"
# package name is vsqlite++, but github / homepage name is vsqlite--
S="${WORKDIR}/vsqlite---${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="dev-db/sqlite:3"
DEPEND="
	${RDEPEND}
	dev-libs/boost"

src_prepare() {
	default
	## remove O3 in AM_CXXFLAGS
	sed -i -e 's/-O3//' Makefile.am || die

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	dodoc VERSION

	find "${ED}" -name '*.la' -delete || die
}
