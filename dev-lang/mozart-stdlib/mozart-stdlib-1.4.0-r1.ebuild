# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit eutils

MY_P="mozart-${PV}.20080704-std"

DESCRIPTION="The Mozart Standard Library"
HOMEPAGE="https://mozart.github.io/ https://github.com/mozart/mozart"
SRC_URI="mirror://sourceforge/project/mozart-oz/v1/1.4.0-2008-07-02-tar/${MY_P}.tar.gz"
LICENSE="Mozart"

SLOT="0"
KEYWORDS="-amd64 ppc -ppc64 x86"
IUSE=""

DEPEND="dev-lang/mozart"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-ozload.patch
	epatch "${FILESDIR}"/${P}-docroot.patch
}

src_install() {
	emake \
		PREFIX="${D}"/usr/lib/mozart \
		DOCROOT="${D}"/usr/share/doc/${PF} \
		install || die "emake install failed"

	dosym /usr/lib/mozart/bin/ozmake /usr/bin/ozmake || die

	doman ozmake/ozmake.1 || die
	docinto mozart-ozmake
	dodoc ozmake/{DESIGN,NOTES,README} || die
}
