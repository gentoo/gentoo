# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="MPEG-1 and MPEG-4 video encoding library"
HOMEPAGE="http://fame.sourceforge.net/"
SRC_URI="mirror://sourceforge/fame/${P}.tar.gz
	http://digilander.libero.it/dgp85/gentoo/${PN}-patches-2.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 sparc x86"
IUSE="cpu_flags_x86_mmx"

PATCHES=(
	"${WORKDIR}"/${PV}
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-mmx-configure.ac.patch
)

src_prepare() {
	default

	mv configure.in configure.ac || die
	rm acinclude.m4 || die

	# Do not add -march=i586, bug #41770.
	sed -i -e 's:-march=i[345]86 ::g' configure.ac || die

	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-static
		$(use_enable cpu_flags_x86_mmx mmx)
	)
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
