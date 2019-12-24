# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools libtool toolchain-funcs multilib-minimal

MY_P="${PN}-III-$(ver_cut 2-3)"
DESCRIPTION="An advanced CDDA reader with error correction"
HOMEPAGE="https://www.xiph.org/paranoia"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${MY_P}.src.tgz
	https://dev.gentoo.org/~pacho/${PN}/${P}-patches.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

RDEPEND="app-eselect/eselect-cdparanoia"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	# Patches from previus patchset + Fedora + Debian
	eapply "${WORKDIR}"/patches/*.patch

	mv configure.guess config.guess
	mv configure.sub config.sub

	sed -i -e '/configure.\(guess\|sub\)/d' configure.in || die

	mv configure.{in,ac} || die
	eautoconf
	elibtoolize

	multilib_copy_sources
}

multilib_src_configure() {
	tc-export AR CC RANLIB
	econf
}

multilib_src_compile() {
	emake OPT="${CFLAGS} -I${S}/interface"
	use static-libs && emake lib OPT="${CFLAGS} -I${S}/interface"
}

multilib_src_install_all() {
	einstalldocs
	mv "${ED}"/usr/bin/${PN}{,-paranoia}
}

pkg_postinst() {
	eselect ${PN} update ifunset
}

pkg_postrm() {
	eselect ${PN} update ifunset
}
