# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit libtool multilib-minimal

DESCRIPTION="Library for parsing, editing, and saving EXIF data"
HOMEPAGE="https://libexif.github.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE="doc nls static-libs"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.13-pkgconfig.patch
	"${FILESDIR}"/${P}-fix-C89-compatibility-issue.patch
	"${FILESDIR}"/${P}-CVE-2017-7544.patch
	"${FILESDIR}"/${P}-CVE-2018-20030.patch
)

src_prepare() {
	default
	sed -i -e '/FLAGS=/s:-g::' configure || die #390249
	elibtoolize # For *-bsd
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		$(use_enable doc docs) \
		$(use_enable nls) \
		$(use_enable static-libs static) \
		--with-doc-dir="${EPREFIX}"/usr/share/doc/${PF}
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete || die
	rm -f "${ED}"/usr/share/doc/${PF}/{ABOUT-NLS,COPYING} || die
}
