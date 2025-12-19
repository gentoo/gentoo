# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools libtool toolchain-funcs multilib-minimal

MY_P="${PN}-III-$(ver_cut 2-3)"
DESCRIPTION="An advanced CDDA reader with error correction"
HOMEPAGE="https://www.xiph.org/paranoia"
SRC_URI="
	https://downloads.xiph.org/releases/${PN}/${MY_P}.src.tgz
	https://dev.gentoo.org/~pacho/${PN}/${P}-patches.tar.xz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="static-libs"

IDEPEND="app-eselect/eselect-cdparanoia"

PATCHES=(
	# Patches from previous patchset + Fedora + Debian
	"${WORKDIR}"/patches
	# bug #713740
	"${FILESDIR}"/${PN}-missing-sys_types_h.patch
	"${FILESDIR}"/cdparanoia-pkgconfig.patch
)

src_prepare() {
	default

	mv configure.guess config.guess || die
	mv configure.sub config.sub || die

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
	mv "${ED}"/usr/bin/${PN}{,-paranoia} || die
}

pkg_postinst() {
	eselect ${PN} update ifunset
}

pkg_postrm() {
	eselect ${PN} update ifunset
}
