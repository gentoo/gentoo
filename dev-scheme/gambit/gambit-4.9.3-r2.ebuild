# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic elisp-common

MY_PV="${PV//./_}"
MY_P="${PN}-v${MY_PV}"

DESCRIPTION="Gambit-C is a native Scheme to C compiler and interpreter"
HOMEPAGE="http://www.iro.umontreal.ca/~gambit/"
SRC_URI="http://www-labs.iro.umontreal.ca/~gambit/download/gambit/v${PV%.*}/source/${MY_P}.tgz"

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/ghostscript-gpl
	emacs? ( >=app-editors/emacs-23.1:* )
"

SITEFILE="50gambit-gentoo.el"

S="${WORKDIR}/${MY_P}" #-devel

IUSE="emacs ssl static"

src_configure() {
	# bug #858254
	filter-lto

	econf \
		$(use_enable !static shared) \
		$(use_enable ssl openssl) \
		--enable-gnu-gcc-specific-options \
		--enable-gnu-gcc-no-strict-aliasing \
		--enable-single-host \
		--disable-absolute-shared-libs \
		--enable-type-checking
}

src_compile() {
	emake bootstrap

	if use emacs; then
		elisp-compile misc/*.el || die
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	keepdir /usr/share/"${MY_PN}"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
