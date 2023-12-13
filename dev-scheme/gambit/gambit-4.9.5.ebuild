# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic elisp-common

DESCRIPTION="Gambit-C is a native Scheme to C compiler and interpreter"
HOMEPAGE="http://gambitscheme.org/
	https://github.com/gambit/gambit/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}-1.tar.gz"

	KEYWORDS="amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="|| ( Apache-2.0 LGPL-2.1 )"
SLOT="0"
IUSE="emacs ssl static"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-text/ghostscript-gpl
	emacs? ( >=app-editors/emacs-23.1:* )
"

DOCS=( INSTALL.txt README README.md )
SITEFILE="50${PN}-gentoo.el"

src_configure() {
	# bug #858254
	filter-lto

	local -a myconf=(
		$(use_enable !static shared)
		$(use_enable ssl openssl)
		--enable-gnu-gcc-specific-options
		--enable-gnu-gcc-no-strict-aliasing
		--enable-single-host
		--disable-absolute-shared-libs
		--enable-type-checking
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake bootstrap

	if use emacs ; then
		elisp-compile misc/*.el
	fi
}

src_test() {
	cd tests || die

	emake test{1..10}
}

src_install() {
	emake DESTDIR="${ED}" install -j1

	if use emacs ; then
		elisp-install "${PN}" misc/*.el{,c}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	dodoc doc/gambit.{pdf,ps,txt}
	einstalldocs

	# Wrong install directory for this ELisp library.
	rm "${ED}/usr/share/emacs/site-lisp/gambit.el" || die

	keepdir "/usr/share/${PN}"
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
