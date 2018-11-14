# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic

DESCRIPTION="Apple branch of the GNU Debugger, 10.5"
HOMEPAGE="https://sourceware.org/gdb/"
SRC_URI="http://www.opensource.apple.com/darwinsource/tarballs/other/gdb-${PV}.tar.gz"

LICENSE="APSL-2 GPL-2"
SLOT="0"

KEYWORDS="~ppc-macos ~x86-macos"

IUSE="nls"

RDEPEND=">=sys-libs/ncurses-5.2-r2
	=dev-db/sqlite-3*"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/gdb-${PV}/src

PATCHES=(
	"${FILESDIR}"/${P}-texinfo.patch
	"${FILESDIR}"/${P}-darwin-arch.patch
)

src_prepare() {
	default
	# for FSF gcc / gcc-apple:42
	sed -e 's/-Wno-long-double//' -i gdb/config/*/macosx.mh
}

src_configure() {
	replace-flags -O? -O2
	econf \
		--disable-werror \
		$(use_enable nls) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" libdir=/nukeme includedir=/nukeme install || die
	rm -r "${D}"/nukeme || die
	rm -Rf "${ED}"/usr/${CHOST} || die
	mv "${ED}"/usr/bin/gdb "${ED}"/
	rm -f "${ED}"/usr/bin/*
	mv "${ED}"/gdb "${ED}"/usr/bin/
}
