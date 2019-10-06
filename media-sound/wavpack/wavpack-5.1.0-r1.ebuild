# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="Hybrid lossless audio compression tools"
HOMEPAGE="http://www.wavpack.com/"
SRC_URI="http://www.wavpack.com/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 ~hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"

RDEPEND=">=virtual/libiconv-0-r1"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-armv7.patch
	"${FILESDIR}"/${P}-CVE-2018-{6767,7253,7254}.patch
	"${FILESDIR}"/${P}-CVE-2018-10536-CVE-2018-10537.patch
	"${FILESDIR}"/${P}-CVE-2018-10538-CVE-2018-10539-CVE-2018-10540.patch
	"${FILESDIR}"/${P}-memleaks.patch
)

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf \
		--disable-static \
		$(multilib_native_enable apps)
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
