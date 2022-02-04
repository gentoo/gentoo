# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Small and fast Portage helper tools written in C"
HOMEPAGE="https://wiki.gentoo.org/wiki/Portage-utils"

LICENSE="GPL-2"
SLOT="0"
IUSE="nls static openmp +qmanifest +qtegrity"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3 autotools
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/portage-utils.git"
else
	SRC_URI="https://dev.gentoo.org/~grobian/distfiles/${P}.tar.xz"
	KEYWORDS="hppa ppc sparc x86"
fi

RDEPEND="
	qmanifest? (
		openmp? (
			|| (
				>=sys-devel/gcc-4.2:*[openmp]
				sys-devel/clang-runtime:*[openmp]
			)
		)
		static? (
			app-crypt/libb2:=[static-libs]
			dev-libs/openssl:0=[static-libs]
			sys-libs/zlib:=[static-libs]
			app-crypt/gpgme:=[static-libs]
		)
		!static? (
			app-crypt/libb2:=
			dev-libs/openssl:0=
			sys-libs/zlib:=
			app-crypt/gpgme:=
		)
	)
	qtegrity? (
		openmp? (
			|| (
				>=sys-devel/gcc-4.2:*[openmp]
				sys-devel/clang-runtime:*[openmp]
			)
		)
		static? (
			dev-libs/openssl:0=[static-libs]
		)
		!static? (
			dev-libs/openssl:0=
		)
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-maintainer-mode \
		--with-eprefix="${EPREFIX}" \
		$(use_enable qmanifest) \
		$(use_enable qtegrity) \
		$(use_enable openmp) \
		$(use_enable static)
}
