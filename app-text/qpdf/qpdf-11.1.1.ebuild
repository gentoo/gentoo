# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake bash-completion-r1

DESCRIPTION="Command-line tool for structural, content-preserving transformation of PDF files"
HOMEPAGE="https://qpdf.sourceforge.net/"
# TODO: verify-sig
SRC_URI="https://github.com/qpdf/qpdf/releases/download/v${PV}/${P}.tar.gz"
SRC_URI+=" doc? ( https://github.com/qpdf/qpdf/releases/download/v${PV}/${P}-doc.zip )"

LICENSE="|| ( Apache-2.0 Artistic-2 )"
# Subslot for libqpdf soname version (just represent via major version)
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE="doc examples gnutls ssl test"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libjpeg-turbo:=
	sys-libs/zlib
	ssl? (
		gnutls? ( net-libs/gnutls:= )
		!gnutls? ( dev-libs/openssl:= )
	)
"
DEPEND="
	${RDEPEND}
	test? (
		app-text/ghostscript-gpl[tiff(+)]
		media-libs/tiff
		sys-apps/diffutils
	)
"
BDEPEND="
	dev-lang/perl
	doc? ( app-arch/unzip )
"

DOCS=( ChangeLog README.md TODO )

src_configure() {
	# Keep an eye on https://qpdf.readthedocs.io/en/stable/packaging.html.
	local mycmakeargs=(
		-DINSTALL_EXAMPLES=$(usex examples)

		# Breaks install with USE=-doc in 11.0.0?
		#-DINSTALL_MANUAL=ON
	)

	if use ssl ; then
		local crypto_provider=$(usex gnutls GNUTLS OPENSSL)
		local crypto_provider_lowercase=${crypto_provider,,}
		mycmakeargs+=(
			-DDEFAULT_CRYPTO=${crypto_provider_lowercase}
			-DREQUIRE_CRYPTO_${crypto_provider}=ON
		)
	fi

	cmake_src_configure
}

src_install() {
	if use doc ; then
		mv "${WORKDIR}"/${P}-doc "${BUILD_DIR}"/manual/doc-dist || die
	fi

	cmake_src_install

	# Completions
	dobashcomp completions/bash/qpdf

	insinto /usr/share/zsh/site-functions
	doins completions/zsh/_qpdf
}
