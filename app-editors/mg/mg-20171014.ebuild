# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="MicroGnuEmacs, a port from the BSDs"
HOMEPAGE="https://homepage.boetes.org/software/mg/"
SRC_URI="https://homepage.boetes.org/software/mg/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ppc ~ppc64 sparc x86"
IUSE="livecd"

RDEPEND="sys-libs/ncurses:0
	!elibc_FreeBSD? ( >=dev-libs/libbsd-0.7.0 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	# fix path to tutorial in man page
	sed -i -e "s:doc/mg/:doc/${PF}/:" mg.1 || die

	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install()  {
	dobin mg
	doman mg.1
	dodoc README tutorial
	# don't compress the tutorial, otherwise mg cannot open it
	docompress -x /usr/share/doc/${PF}/tutorial
}

pkg_postinst() {
	if use livecd; then
		[[ -e ${EROOT}/usr/bin/emacs ]] || ln -s mg "${EROOT}"/usr/bin/emacs
	fi
}
