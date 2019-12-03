# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal

DESCRIPTION="The Ogg Vorbis sound file format library"
HOMEPAGE="https://xiph.org/vorbis/"
SRC_URI="https://downloads.xiph.org/releases/vorbis/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs test"

RESTRICT="!test? ( test )"

BDEPEND="virtual/pkgconfig"

RDEPEND=">=media-libs/libogg-1.3.0[${MULTILIB_USEDEP}]"

DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-CVE-2017-14160.patch
	"${FILESDIR}"/${P}-CVE-2018-10392.patch
)

src_prepare() {
	default

	sed -i \
		-e '/CFLAGS/s:-O20::' \
		-e '/CFLAGS/s:-mcpu=750::' \
		-e '/CFLAGS/s:-mno-ieee-fp::' \
		configure.ac || die

	# Un-hack docdir redefinition.
	find -name 'Makefile.am' \
		-exec sed -i \
			-e 's:$(datadir)/doc/$(PACKAGE)-$(VERSION):@docdir@/html:' \
			{} + || die

	eautoreconf
}

multilib_src_configure() {
	local myconf=(
		--enable-shared
		$(use_enable static-libs static)
		$(use_enable test oggtest)
	)

	einfo "Running configure in ${BUILD_DIR}"
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die
}
