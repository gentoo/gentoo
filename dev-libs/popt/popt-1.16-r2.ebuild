# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/popt/popt-1.16-r2.ebuild,v 1.9 2015/03/13 19:55:13 zlogene Exp $

EAPI=5
inherit eutils multilib-minimal

DESCRIPTION="Parse Options - Command line parser"
HOMEPAGE="http://rpm5.org/"
SRC_URI="http://rpm5.org/files/popt/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="nls static-libs"

RDEPEND="nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )"
DEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	epatch "${FILESDIR}"/fix-popt-pkgconfig-libdir.patch #349558
	sed -i -e 's:lt-test1:test1:' testit.sh || die
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
