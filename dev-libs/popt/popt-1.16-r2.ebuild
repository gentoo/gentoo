# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils multilib-minimal libtool

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="http://rpm5.org/"
SRC_URI="http://rpm5.org/files/popt/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86 ~x86-linux"
IUSE="nls static-libs"

RDEPEND="nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/fix-popt-pkgconfig-libdir.patch #349558
	sed -i -e 's:lt-test1:test1:' testit.sh || die
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable nls)
}

multilib_src_install_all() {
	dodoc CHANGES README
	prune_libtool_files --all
}
