# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp-common

DESCRIPTION="Gambit-C is a native Scheme to C compiler and interpreter"
HOMEPAGE="http://www.iro.umontreal.ca/~gambit/"
SRC_URI="https://github.com/${PN}/${PN}/archive/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-tags-v${PV}"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="emacs ssl static"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/ghostscript-gpl
	emacs? ( >=app-editors/emacs-23.1:* )
"

DOCS=( INSTALL.txt README README.md )
SITEFILE="50gambit-gentoo.el"

src_configure() {
	local myconf=(
		$(use_enable !static shared)
		$(use_enable ssl openssl)
		--enable-gnu-gcc-specific-options
		--enable-gnu-gcc-no-strict-aliasing
		--enable-single-host
		--disable-absolute-shared-libs
		--enable-type-checking
	)
	econf ${myconf[@]}
}

src_compile() {
	emake bootstrap

	if use emacs; then
		elisp-compile misc/*.el || die
	fi
}

src_test() {
	cd tests || die
	emake test{1..10}
}

src_install() {
	emake DESTDIR="${D}" install -j1
	dodoc doc/gambit.{pdf,ps,txt}
	einstalldocs

	keepdir /usr/share/${PN}
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
