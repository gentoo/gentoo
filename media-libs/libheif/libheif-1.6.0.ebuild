# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools xdg-utils multilib-minimal

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/strukturag/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/strukturag/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
fi

DESCRIPTION="ISO/IEC 23008-12:2017 HEIF file format decoder and encoder"
HOMEPAGE="https://github.com/strukturag/libheif"

LICENSE="GPL-3"
SLOT="0/1.6"
IUSE="static-libs test +threads"

RESTRICT="!test? ( test )"

BDEPEND="test? ( dev-lang/go )"
DEPEND="
	media-libs/libde265:=[${MULTILIB_USEDEP}]
	media-libs/libpng:0=[${MULTILIB_USEDEP}]
	media-libs/x265:=[${MULTILIB_USEDEP}]
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	virtual/jpeg:0=[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e 's:-Werror::' configure.ac || die

	eautoreconf

	# prevent "stat heif-test.go: no such file or directory"
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable threads multithreading)
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}

pkg_postinst() {
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}
