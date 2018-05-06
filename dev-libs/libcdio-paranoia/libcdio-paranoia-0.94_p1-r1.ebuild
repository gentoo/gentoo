# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_P=${PN}-10.2+${PV/_p/+}

inherit eutils autotools multilib-minimal flag-o-matic

DESCRIPTION="an advanced CDDA reader with error correction"
HOMEPAGE="https://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN%-*}/${MY_P}.tar.gz"

# COPYING-GPL from cdparanoia says "2 or later"
# COPYING-LGPL from cdparanoia says "2.1 or later" but 2 files are without the
# clause "or later" so we use LGPL-2.1 without +
LICENSE="GPL-3+ GPL-2+ LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="+cxx static-libs test"

RDEPEND="app-eselect/eselect-cdparanoia
	>=dev-libs/libcdio-0.94:0=[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
"

DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-lang/perl )"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog NEWS README.md THANKS )

PATCHES=("${FILESDIR}"/${PN}-0.90-oos-tests.patch)

src_prepare() {
	default
	sed -i -e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' configure.ac || die #466410
	eautoreconf

	[[ ${CC} == *clang* ]] && append-flags -std=gnu89
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-maintainer-mode
		--disable-example-progs
		$(use_enable cxx)
		--disable-cpp-progs
		--with-cd-paranoia-name=libcdio-paranoia
		# upstream accidentally default-disabled it
		# reenable it to preserve ABI compat with previous versions
		# https://bugs.gentoo.org/616054
		# https://savannah.gnu.org/bugs/index.php?50978
		--enable-ld-version-script
	)
	# Darwin linker doesn't get this
	[[ ${CHOST} == *-darwin* ]] && myeconfargs+=( --disable-ld-version-script )
	ECONF_SOURCE="${S}" \
	econf "${myeconfargs[@]}"
}

pkg_postinst() {
	eselect cdparanoia update ifunset
}

pkg_postrm() {
	eselect cdparanoia update ifunset
}
