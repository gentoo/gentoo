# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Chroot any dynamically linked application in a safe and sane manner"
HOMEPAGE="http://chrootsafe.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN//_}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=( "${FILESDIR}"/${P}-ldflags.patch )

src_configure() {
	econf --libexecdir="${EPREFIX}/usr/$(get_libdir)"
}

src_compile() {
	emake CPPFLAGS="${CXXFLAGS}" CXX="$(tc-getCXX)"
}

src_install() {
	dolib.so chroot_safe.so
	dosbin chroot_safe
	sed -i -e "s:/chroot_safe::" "${ED}"/usr/sbin/chroot_safe \
		|| die "sed chroot_safe failed"
	doman chroot_safe.1
	dodoc CHANGES.txt
}
