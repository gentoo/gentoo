# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1

DESCRIPTION="Command-line tool for structural, content-preserving transformation of PDF files"
HOMEPAGE="http://qpdf.sourceforge.net/"
SRC_URI="mirror://sourceforge/qpdf/${P}.tar.gz"
SRC_URI+=" doc? ( mirror://sourceforge/qpdf/${P}-doc.zip )"

LICENSE="|| ( Apache-2.0 Artistic-2 )"
# subslot = libqpdf soname version
SLOT="0/28"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE="doc examples gnutls ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib
	virtual/jpeg:0=
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
DEPEND="${RDEPEND}
	test? (
		app-text/ghostscript-gpl[tiff(+)]
		media-libs/tiff
		sys-apps/diffutils
	)
"
BDEPEND="dev-lang/perl
	doc? ( app-arch/unzip )"

DOCS=( ChangeLog README.md TODO )

src_configure() {
	# Keep an eye on https://qpdf.readthedocs.io/en/stable/packaging.html.
	local myeconfargs=(
		--disable-check-autofiles

		--disable-implicit-crypto
		--enable-crypto-native

		--disable-oss-fuzz
		$(use_enable test test-compare-images)
	)

	if use ssl ; then
		local crypto_provider=openssl

		if use gnutls ; then
			crypto_provider=gnutls
		fi

		myeconfargs+=(
			--with-default-crypto=${crypto_provider}
			--enable-crypto-${crypto_provider}
		)
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	if use doc ; then
		docompress -x /usr/share/doc/${PF}/singlehtml
		dodoc -r "${WORKDIR}"/${P}-doc/.

	fi

	if use examples ; then
		dobin $(find examples/build/.libs -maxdepth 1 -type f -executable || die)
	fi

	# Completions
	dobashcomp completions/bash/qpdf

	insinto /usr/share/zsh/site-functions
	doins completions/zsh/_qpdf

	find "${ED}" -type f -name '*.la' -delete || die
}
