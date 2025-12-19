# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Xiph's last (cd/lib)paranoia was 10.2. This fork is versioned accordingly
# by declaring its version as 10.2+${PV}.
MY_P=${PN}-10.2+${PV/_p/+}

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Advanced CDDA reader with error correction"
HOMEPAGE="https://www.gnu.org/software/libcdio/"
SRC_URI="mirror://gnu/${PN%-*}/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

# COPYING-GPL from cdparanoia says "2 or later"
# COPYING-LGPL from cdparanoia says "2.1 or later" but 2 files are without the
# clause "or later" so we use LGPL-2.1 without +
LICENSE="GPL-3+ GPL-2+ LGPL-2.1"
SLOT="0/2" # soname version
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"
IUSE="+cxx static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-eselect/eselect-cdparanoia
	>=dev-libs/libcdio-2.0.0:0=[${MULTILIB_USEDEP}]
	>=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	test? ( dev-lang/perl )
"
DOCS=( AUTHORS ChangeLog NEWS.md README.md THANKS )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Drop this after 2.0.2 (bug #945207)
	append-cflags -std=gnu17

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-example-progs
		--disable-cpp-progs
		--with-cd-paranoia-name=libcdio-paranoia
		$(use_enable cxx)
		$(use_enable static-libs static)
	)
	# Darwin linker doesn't get this
	[[ ${CHOST} == *-darwin* ]] && myeconfargs+=( --disable-ld-version-script )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	eselect cdparanoia update ifunset
}

pkg_postrm() {
	eselect cdparanoia update ifunset
}
