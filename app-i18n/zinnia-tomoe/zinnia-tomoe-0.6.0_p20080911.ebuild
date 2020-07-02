# Copyright 2013-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

MY_P="${P/_p/-}"

DESCRIPTION="Handwriting model files trained with Tomoe data"
HOMEPAGE="https://taku910.github.io/zinnia/ https://github.com/taku910/zinnia https://sourceforge.net/projects/zinnia/"
SRC_URI="mirror://sourceforge/zinnia/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"
IUSE=""

DEPEND="app-i18n/zinnia"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=(AUTHORS)

src_prepare() {
	default
	mv configure.in configure.ac || die
	sed -e "/^modeldir[[:space:]]*=/s/lib/$(get_libdir)/" -i Makefile.am || die
	eautoreconf
}
