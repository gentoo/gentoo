# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Linux shell program that talks the date and system uptime"
HOMEPAGE="http://unihedron.com/projects/saydate/saydate.php"
SRC_URI="http://unihedron.com/projects/saydate/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 sparc x86"

S=${WORKDIR}/${PN}

src_prepare() {
	default

	sed -i 's:/dev/audio:/dev/dsp:' saydate au2raw DESIGN || die

	# don't install pre-compressed files
	gunzip man/{saydate,au2raw}.1.gz || die
}

src_compile() {
	# Don't leave this empty or it tries
	# to install directly on livefs
	:
}

src_install() {
	dobin saydate au2raw

	insinto /usr/share/saydate
	doins data/*.raw

	doman man/{saydate,au2raw}.1
	dodoc README TODO HISTORY DESIGN
}
