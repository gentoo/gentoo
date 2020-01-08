# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit elisp-common eutils toolchain-funcs

DESCRIPTION="window manager without mouse dependency"
HOMEPAGE="http://www.nongnu.org/ratpoison/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug emacs +history sloppy +xft"

RDEPEND="
	emacs? ( >=app-editors/emacs-23.1:* )
	history? ( sys-libs/readline:= )
	xft? ( x11-libs/libXft )
	virtual/perl-Pod-Parser
	x11-libs/libXinerama
	x11-libs/libXtst
"
DEPEND="
	${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig
"

SITEFILE=50ratpoison-gentoo.el
DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	epatch "${FILESDIR}"/ratpoison.el-gentoo.patch
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable history) \
		$(use_with xft)
}

src_compile() {
	emake CFLAGS="${CFLAGS}"
	if use emacs; then
		elisp-compile contrib/ratpoison.el || die "elisp-compile failed"
	fi

	if use sloppy; then
		pushd contrib
		$(tc-getCC) \
			${CFLAGS} \
			${LDFLAGS} \
			-o sloppy{,.c} \
			$( $(tc-getPKG_CONFIG) --libs x11) \
			|| die
	fi
}

src_install() {
	default

	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/ratpoison.xsession ratpoison

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/${PN}.desktop

	use sloppy && dobin contrib/sloppy

	docinto example
	dodoc contrib/{genrpbindings,split.sh} \
		doc/{ipaq.ratpoisonrc,sample.ratpoisonrc}

	rm -rf "${ED}/usr/share/"{doc/ratpoison,ratpoison}

	if use emacs; then
		elisp-install ${PN} contrib/ratpoison.*
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
