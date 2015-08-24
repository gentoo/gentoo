# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=xdelta3-${PV}

DESCRIPTION="a binary diff and differential compression tools. VCDIFF (RFC 3284) delta compression"
HOMEPAGE="http://xdelta.org/"
SRC_URI="https://${PN}.googlecode.com/files/${MY_P}.tar.xz"
SRC_URI="https://github.com/jmacd/xdelta-devel/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="examples lzma test"

RDEPEND="lzma? ( app-arch/xz-utils:= )"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	econf \
		$(use_with lzma liblzma)
}

src_compile() {
	# avoid building tests
	emake xdelta3
}

src_test() {
	emake xdelta3regtest
	./xdelta3regtest || die
}

src_install() {
	emake DESTDIR="${D}" install-binPROGRAMS install-man1
	dodoc draft-korn-vcdiff.txt README.md
	use examples && dodoc -r examples
}
