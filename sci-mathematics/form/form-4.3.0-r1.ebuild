# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs elisp-common

DESCRIPTION="Symbolic Manipulation System"
HOMEPAGE="https://www.nikhef.nl/~form/ https://github.com/vermaseren/form/"
SRC_URI="https://github.com/vermaseren/${PN}/releases/download/v${PV}/${P}.tar.gz
	emacs? ( https://dev.gentoo.org/~grozin/form-mode.el.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="devref doc doxygen emacs gmp mpi threads zlib"

RDEPEND="
	gmp? ( dev-libs/gmp:0= )
	mpi? ( virtual/mpi )
	zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	devref? ( dev-texlive/texlive-latexrecommended )
	doc? ( dev-texlive/texlive-latexrecommended )
	doxygen? ( app-doc/doxygen )
	emacs? ( app-editors/emacs:* )"

SITEFILE="64${PN}-gentoo.el"

src_prepare() {
	default
	sed -i 's/LINKFLAGS = -s/LINKFLAGS =/' sources/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--enable-scalar \
		--enable-largefile \
		--disable-debug \
		--disable-static-link \
		--with-api=posix \
		$(use_with gmp ) \
		$(use_enable mpi parform ) \
		$(use_enable threads threaded ) \
		$(use_with zlib ) \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CXXFLAGS="${CXXFLAGS}"
}

src_compile() {
	default
	if use devref; then
		pushd doc/devref > /dev/null || die "doc/devref does not exist"
		LANG=C VARTEXFONTS="${T}/fonts" emake pdf
		popd > /dev/null
	fi
	if use doc; then
		pushd doc/manual > /dev/null || die "doc/manual does not exist"
		LANG=C VARTEXFONTS="${T}/fonts" emake pdf
		popd > /dev/null
	fi
	if use doxygen; then
		pushd doc/doxygen > /dev/null || die "doc/doxygen does not exist"
		emake html
		popd > /dev/null
	fi
}

src_install() {
	default
	if use devref; then
		dodoc doc/devref/devref.pdf
	fi
	if use doc; then
		dodoc doc/manual/manual.pdf
	fi
	if use doxygen; then
		docinto html
		dodoc -r doc/doxygen/html/.
	fi
	if use emacs; then
		elisp-install ${PN} "${WORKDIR}"/*.el
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
