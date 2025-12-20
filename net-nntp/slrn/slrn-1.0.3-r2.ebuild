# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

MY_P="${P}a"

DESCRIPTION="A s-lang based newsreader"
HOMEPAGE="
	https://slrn.sourceforge.net/
	https://github.com/jedsoft/slrn
"
SRC_URI="https://jedsoft.org/releases/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="canlock nls selinux ssl uudeview"

RDEPEND="app-arch/sharutils
	>=sys-libs/slang-2.2.3
	virtual/mta
	canlock? ( net-libs/canlock:=[legacy(+)] )
	ssl? (
		dev-libs/openssl:0=
	)
	uudeview? ( dev-libs/uulib )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND+=" selinux? ( sec-policy/selinux-slrnpull )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2-make.patch
	"${FILESDIR}"/${P}-configure.patch
)

QA_CONFIG_IMPL_DECL_SKIP=(
	__va_copy # bug #900270, pre-C99 extension, using standard va_copy() instead
)

src_configure() {
	append-cppflags -DPROTOTYPES # fix c23
	econf \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-slrnpull \
		$(use_with canlock canlock /usr) \
		$(use_enable nls) \
		$(use_with ssl) \
		$(use_with uudeview uu)
}
