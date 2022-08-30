# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools multilib-minimal

DESCRIPTION="Library for parsing, editing, and saving EXIF data"
HOMEPAGE="https://libexif.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
IUSE="doc nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.13-pkgconfig.patch
)

src_prepare() {
	default

	# bug #390249
	sed -i -e '/FLAGS=/s:-g::' configure.ac || die

	# Previously elibtoolize for BSD
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(multilib_native_use_enable doc docs) \
		$(use_enable nls) \
		--with-doc-dir="${EPREFIX}"/usr/share/doc/${PF}
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	rm -f "${ED}"/usr/share/doc/${PF}/{ABOUT-NLS,COPYING} || die
}
