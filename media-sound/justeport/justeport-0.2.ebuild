# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mono multilib

MY_P=JustePort-${PV}

DESCRIPTION="Stream audio to your AirPort Express"
HOMEPAGE="http://nanocrew.net/software/justeport/"
SRC_URI="http://nanocrew.net/sw/justeport/${MY_P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/mono"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/$(get_libdir)/justeport
	doins *.exe
	newbin - justeport \
		< <(sed -e "s:LIBDIR:$(get_libdir):" "${FILESDIR}"/wrapper-script)
	dodoc AUTHORS ChangeLog README THANKS
}
