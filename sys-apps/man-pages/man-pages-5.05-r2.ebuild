# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENTOO_PATCH=2

DESCRIPTION="A somewhat comprehensive collection of Linux man pages"
HOMEPAGE="https://www.kernel.org/doc/man-pages/"
SRC_URI="https://www.kernel.org/pub/linux/docs/man-pages/Archive/${P}.tar.xz
	https://www.kernel.org/pub/linux/docs/man-pages/${P}.tar.xz
	mirror://gentoo/man-pages-gentoo-${GENTOO_PATCH}.tar.bz2
	https://dev.gentoo.org/~cardoe/files/man-pages-gentoo-${GENTOO_PATCH}.tar.bz2"

LICENSE="man-pages GPL-2+ BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE_L10N=" de fr it ja nl pl ru zh-CN"
IUSE="${IUSE_L10N// / l10n_}"
RESTRICT="binchecks"

# Block packages that used to install colliding man pages #341953 #548900 #612640 #617462
RDEPEND="virtual/man
	!<sys-apps/keyutils-1.5.9-r4
	!<dev-libs/libbsd-0.8.3-r1"
PDEPEND="
	l10n_de? ( app-i18n/man-pages-l10n[l10n_de] )
	l10n_fr? ( app-i18n/man-pages-l10n[l10n_fr] )
	l10n_it? ( app-i18n/man-pages-it )
	l10n_ja? ( app-i18n/man-pages-ja )
	l10n_nl? ( app-i18n/man-pages-l10n[l10n_nl] )
	l10n_pl? ( app-i18n/man-pages-l10n[l10n_pl] )
	l10n_ru? ( app-i18n/man-pages-ru )
	l10n_zh-CN? ( app-i18n/man-pages-zh_CN )
	sys-apps/man-pages-posix"

src_configure() { :; }

src_compile() { :; }

src_install() {
	emake install prefix="${EPREFIX}/usr" DESTDIR="${D}"
	dodoc man-pages-*.Announce README Changes*

	# Override with Gentoo specific or additional Gentoo pages
	cd "${WORKDIR}"/man-pages-gentoo || die
	doman */*
	dodoc README.Gentoo
}
