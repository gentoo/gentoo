# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P="${P}a"

DESCRIPTION="A s-lang based newsreader"
HOMEPAGE="http://slrn.sourceforge.net/"
SRC_URI="https://jedsoft.org/releases/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="canlock libressl nls ssl uudeview"

RDEPEND="app-arch/sharutils
	>=sys-libs/slang-2.2.3
	virtual/mta
	canlock? ( net-libs/canlock )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	uudeview? ( dev-libs/uulib )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}"/${PN}-1.0.2-make.patch )

src_configure() {
	econf \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-slrnpull \
		$(use_with canlock) \
		$(use_enable nls) \
		$(use_with ssl) \
		$(use_with uudeview uu)
}
