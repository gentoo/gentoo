# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

GENTOO_PATCH=2

DESCRIPTION="A somewhat comprehensive collection of Linux man pages"
HOMEPAGE="https://www.kernel.org/doc/man-pages/"
SRC_URI="mirror://kernel/linux/docs/man-pages/Archive/${P}.tar.xz
	mirror://kernel/linux/docs/man-pages/${P}.tar.xz
	http://man7.org/linux/man-pages/download/${P}.tar.xz
	mirror://gentoo/man-pages-gentoo-${GENTOO_PATCH}.tar.bz2
	https://dev.gentoo.org/~cardoe/files/man-pages-gentoo-${GENTOO_PATCH}.tar.bz2"

LICENSE="man-pages GPL-2+ BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~ia64-linux ~x86-linux"
IUSE_LINGUAS=" da de fr it ja nl pl ro ru zh_CN"
IUSE="nls ${IUSE_LINGUAS// / linguas_}"
RESTRICT="binchecks"

# Block packages that used to install colliding man pages #341953 #548900
RDEPEND="virtual/man
	!<sys-apps/attr-2.4.47-r2
	!<dev-libs/libaio-0.3.109-r2"
PDEPEND="nls? (
	linguas_da? ( app-i18n/man-pages-da )
	linguas_de? ( app-i18n/man-pages-de )
	linguas_fr? ( app-i18n/man-pages-fr )
	linguas_it? ( app-i18n/man-pages-it )
	linguas_ja? ( app-i18n/man-pages-ja )
	linguas_nl? ( app-i18n/man-pages-nl )
	linguas_pl? ( app-i18n/man-pages-pl )
	linguas_ro? ( app-i18n/man-pages-ro )
	linguas_ru? ( app-i18n/man-pages-ru )
	linguas_zh_CN? ( app-i18n/man-pages-zh_CN )
	)
	sys-apps/man-pages-posix"

src_configure() { :; }

src_compile() { :; }

src_install() {
	emake install prefix="${EPREFIX}/usr" DESTDIR="${D}"
	dodoc man-pages-*.Announce README Changes*

	# Override with Gentoo specific or additional Gentoo pages
	cd "${WORKDIR}"/man-pages-gentoo
	doman */*
	dodoc README.Gentoo
}
