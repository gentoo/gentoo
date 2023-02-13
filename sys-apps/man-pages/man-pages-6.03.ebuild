# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Maintenance notes:
# - Upstream are very friendly, do approach them if have any questions;
#
# - It's considered fine (and somewhat encouraged) for us to make snapshots
#   if we want specific fixes, perhaps aligned with newer kernels, glibc, etc.
#   Just generate it with 'make dist'. We can set DISTVERSION if we want a vanity
#   name or if the comit hash is too long;
#
# - If we do use a snapshot, *don't* grab it directly from git and use it
#   raw in the ebuild. Use 'make dist' as above;
#
# - Sometimes there's no dist tarball available post-release and upstream
#   encourage distros to make their own. Set MAN_PAGES_GENTOO_DIST to 1 if none is
#   available, 0 otherwise.
MAN_PAGES_GENTOO_DIST=0
GENTOO_PATCH=2

DESCRIPTION="A somewhat comprehensive collection of Linux man pages"
HOMEPAGE="https://www.kernel.org/doc/man-pages/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git"
	inherit git-r3
elif [[ ${PV} == *_rc* ]] ; then
	MY_P=${PN}-${PV/_/-}

	SRC_URI="https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/snapshot/${MY_P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
else
	if [[ ${MAN_PAGES_GENTOO_DIST} -eq 1 ]] ; then
		SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-gentoo.tar.xz"
	else
		SRC_URI="
			https://www.kernel.org/pub/linux/docs/man-pages/Archive/${P}.tar.xz
			https://www.kernel.org/pub/linux/docs/man-pages/${P}.tar.xz
		"
	fi

	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
fi

SRC_URI+="
	mirror://gentoo/man-pages-gentoo-${GENTOO_PATCH}.tar.bz2
	https://dev.gentoo.org/~cardoe/files/man-pages-gentoo-${GENTOO_PATCH}.tar.bz2
"

LICENSE="man-pages GPL-2+ BSD"
SLOT="0"
# Keep the following in sync with app-i18n/man-pages-l10n
MY_L10N=( cs da de el es fi fr hu id it mk nb nl pl pt-BR ro sr sv uk vi )
IUSE="l10n_ja l10n_ru l10n_zh-CN ${MY_L10N[@]/#/l10n_}"
RESTRICT="binchecks"

BDEPEND="
	sys-devel/bc
"
# Block packages that used to install colliding man pages:
# bug #341953, bug #548900, bug #612640, bug #617462
RDEPEND="
	virtual/man
	!<sys-apps/keyutils-1.5.9-r4
	!<dev-libs/libbsd-0.8.3-r1
"
PDEPEND="
	l10n_ja? ( app-i18n/man-pages-ja )
	l10n_ru? ( || (
		app-i18n/man-pages-l10n[l10n_ru(-)]
		app-i18n/man-pages-ru
	) )
	l10n_zh-CN? ( app-i18n/man-pages-zh_CN )
"
for lang in "${MY_L10N[@]}"; do
	PDEPEND+=" l10n_${lang}? ( app-i18n/man-pages-l10n[l10n_${lang}(-)] )"
done
unset lang

src_unpack() {
	default

	[[ ${PV} == 9999 ]] && git-r3_src_unpack
}

src_prepare() {
	default

	# passwd.5 installed by sys-apps/shadow, bug #776787
	rm man5/passwd.5 || die
}

src_compile() { :; }

src_install() {
	emake install prefix="${EPREFIX}"/usr DESTDIR="${D}"
	dodoc README Changes*

	# Override with Gentoo specific or additional Gentoo pages
	cd "${WORKDIR}"/man-pages-gentoo || die
	doman */*
	dodoc README.Gentoo
}

pkg_postinst() {
	for ver in ${REPLACING_VERSIONS} ; do
		if ver_test ${ver} -lt 5.13-r2 ; then
			# Avoid ACCEPT_LICENSE issues for users by default
			# bug #871636
			ewarn "This version of ${PN} no longer depends on sys-apps/man-pages-posix!"
			ewarn "Please install sys-apps/man-pages-posix yourself if needed."
			break
		fi
	done
}
