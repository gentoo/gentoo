# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/kyz/libmspack.git"
	inherit autotools git-r3
	MY_P="${PN}-9999"

	LIBMSPACK_DEPEND="~dev-libs/libmspack-9999:="
else
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
	MY_PV="${PV/_alpha/alpha}"
	MY_P="${PN}-${MY_PV}"
	SRC_URI="https://www.cabextract.org.uk/${P}.tar.gz"

	LIBMSPACK_DEPEND=">=dev-libs/libmspack-0.8_alpha:="
fi

DESCRIPTION="Extracts files from Microsoft cabinet archive files"
HOMEPAGE="https://www.cabextract.org.uk/"

LICENSE="GPL-3"
SLOT="0"
IUSE="extras"

DEPEND="${LIBMSPACK_DEPEND}"
RDEPEND="${LIBMSPACK_DEPEND}
	extras? ( dev-lang/perl )"
BDEPEND="sys-devel/gettext
	virtual/pkgconfig"

src_prepare() {
	if [[ ${PV} == "9999" ]] ; then
		# Re-create file layout from release tarball
		pushd "${WORKDIR}" &>/dev/null || die
		cp -aL "${S}"/${PN} "${WORKDIR}"/${PN}-source || die
		rm -r "${S}" || die
		mv "${WORKDIR}"/${PN}-source "${S}" || die
		popd &>/dev/null || die
	fi

	default

	# 956793, use getopt from glibc / musl instead
	rm getopt.h || die

	[[ ${PV} == "9999" ]] && eautoreconf
}

src_configure() {
	econf \
		--with-external-libmspack=yes
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README TODO doc/magic )
	default
	docinto html
	dodoc doc/wince_cab_format.html
	if use extras; then
		dobin src/{wince_info,wince_rename,cabinfo,cabsplit}
	fi
}
