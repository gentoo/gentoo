# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake shell-completion verify-sig

DESCRIPTION="Command-line tool for structural, content-preserving transformation of PDF files"
HOMEPAGE="
	https://qpdf.sourceforge.io/
	https://github.com/qpdf/qpdf/
"
SRC_URI="
	https://github.com/qpdf/qpdf/releases/download/v${PV}/${P}.tar.gz
	doc? (
		https://github.com/qpdf/qpdf/releases/download/v${PV}/${P}-doc.zip
	)
	verify-sig? (
		https://github.com/qpdf/qpdf/releases/download/v${PV}/${P}.tar.gz.asc
	)
"

LICENSE="|| ( Apache-2.0 Artistic-2 )"
# Subslot for libqpdf soname version (just represent via major version)
SLOT="0/$(ver_cut 1)"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="doc examples gnutls test zopfli"
RESTRICT="!test? ( test )"

RDEPEND="
	media-libs/libjpeg-turbo:=
	virtual/zlib:=
	gnutls? ( net-libs/gnutls:= )
	!gnutls? ( dev-libs/openssl:= )
	zopfli? ( app-arch/zopfli:= )
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
	verify-sig? ( sec-keys/openpgp-keys-jberkenbilt )
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# glibc only (bug #899052)
	malloc_info
)

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/jberkenbilt.asc

src_unpack() {
	if use verify-sig ; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.asc}
	fi

	default
}

src_configure() {
	local crypto_provider=$(usex gnutls GNUTLS OPENSSL)
	local crypto_provider_lowercase=${crypto_provider,,}

	# Keep an eye on https://qpdf.readthedocs.io/en/stable/packaging.html.
	local mycmakeargs=(
		-DINSTALL_EXAMPLES=$(usex examples)
		-DZOPFLI=$(usex zopfli)

		# Avoid automagic crypto deps
		-DUSE_IMPLICIT_CRYPTO=OFF
		-DALLOW_CRYPTO_NATIVE=ON

		# Breaks install with USE=-doc in 11.0.0?
		#-DINSTALL_MANUAL=ON

		-DDEFAULT_CRYPTO=${crypto_provider_lowercase}
		-DREQUIRE_CRYPTO_${crypto_provider}=ON
	)

	cmake_src_configure
}

src_install() {
	if use doc ; then
		mv "${WORKDIR}"/${P}-doc "${BUILD_DIR}"/manual/doc-dist || die
	fi

	cmake_src_install

	# Completions
	dobashcomp completions/bash/qpdf
	dozshcomp completions/zsh/_qpdf
}
