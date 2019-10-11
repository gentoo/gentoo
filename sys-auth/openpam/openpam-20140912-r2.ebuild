# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools multilib-minimal

DESCRIPTION="Open source PAM library"
HOMEPAGE="https://www.openpam.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="!sys-libs/pam"
DEPEND="
	sys-devel/make
	dev-lang/perl"

PDEPEND="
	sys-auth/pambase"

PATCHES=(
	"${FILESDIR}/${PN}-20130907-gentoo.patch"
	"${FILESDIR}/${PN}-20130907-nbsd.patch"
	"${FILESDIR}/${PN}-20130907-module-dir.patch"
)

src_prepare() {
	sed -i -e 's:-Werror::' "${S}/configure.ac"
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--with-modules-dir=/$(get_libdir)/security
	)
	ECONF_SOURCE=${S} \
	econf "${myconf[@]}"
}

multilib_src_install_all() {
	dodoc CREDITS HISTORY RELNOTES README
	find "${D}" -name '*.la' -delete || die
}
