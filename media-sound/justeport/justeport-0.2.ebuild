# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit mono multilib

MY_P=JustePort-${PV}

DESCRIPTION="Stream audio to your AirPort Express"
HOMEPAGE="http://nanocrew.net/software/justeport/"
SRC_URI="http://nanocrew.net/sw/justeport/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	cp "${FILESDIR}"/wrapper-script .
	sed -i -e "s:LIBDIR:$(get_libdir):" wrapper-script || die "sed failed."
}

src_compile() {
	emake || die "emake failed."
}

src_install() {
	insinto /usr/$(get_libdir)/justeport
	doins *.exe || die "doins failed."
	newbin wrapper-script justeport || die "newbin failed."
	dodoc AUTHORS ChangeLog README THANKS
}
