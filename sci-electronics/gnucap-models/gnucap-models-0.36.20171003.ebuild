# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

SNAPSHOTDATE="${PV##*.}"
MY_P="${PN}-${SNAPSHOTDATE}"

DESCRIPTION="Models for the GNU Circuit Analysis Package"
SRC_URI="http://git.savannah.gnu.org/cgit/gnucap/${PN}.git/snapshot/${MY_P}.tar.gz"
HOMEPAGE="http://www.gnucap.org/"

IUSE=""
SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="~sci-electronics/gnucap-${PV}"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed -i -e 's:INSTALL_DIR = :INSTALL_DIR = $(DESTDIR):' \
		-e 's:C_CC_FLAGS = -O2 -g:C_CC_FLAGS = :' \
		-e 's:CFLAGS =:CFLAGS +=:' \
		-e 's:CCFLAGS =:CCFLAGS = ${CXXFLAGS}:' \
		-e 's:LDFLAGS =:LDFLAGS +=:' \
		plugins/models-*/Make2 || die "sed failed"
}

src_compile () {
	emake CC="$(tc-getCC)" CCC="$(tc-getCXX)"
}
