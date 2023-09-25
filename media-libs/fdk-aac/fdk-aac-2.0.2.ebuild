# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/mstorsjo/${PN}.git"
	[[ ${PV%9999} != "" ]] && EGIT_BRANCH="release/${PV%.9999}"
	inherit autotools git-r3
else
	inherit libtool
	KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv x86 ~x64-macos"
	if [[ ${PV%_p*} != ${PV} ]]; then # Gentoo snapshot
		SRC_URI="mirror://gentoo/${P}.tar.xz"
	else # Official release
		SRC_URI="mirror://sourceforge/opencore-amr/${P}.tar.gz"
	fi
fi

DESCRIPTION="Fraunhofer AAC codec library"
HOMEPAGE="https://sourceforge.net/projects/opencore-amr/"
LICENSE="FraunhoferFDK"
# subslot == N where N is libfdk-aac.so.N
SLOT="0/2"

IUSE="examples"

PATCHES=( "${FILESDIR}"/${P}-always_inline.patch )

src_prepare() {
	default

	if [[ ${PV} == *9999* ]] ; then
		eautoreconf
	else
		elibtoolize
	fi
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(multilib_native_use_enable examples example)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		mv "${ED}/usr/bin/"{,fdk-}aac-enc || die
	fi

	# package provides .pc files
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	use examples && einfo "aac-enc was renamed to fdk-aac-enc to prevent file collision with other packages"
}
