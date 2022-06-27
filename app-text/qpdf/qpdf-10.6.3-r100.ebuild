# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake bash-completion-r1

if [[ ${PVR} != 10.6.3-r100 ]] ; then
	# See https://github.com/qpdf/qpdf/releases/tag/release-qpdf-10.6.3.0cmake1
	die "Please update the ebuild / be careful with using it, as it's for previewing CMake!"
fi

DESCRIPTION="Command-line tool for structural, content-preserving transformation of PDF files"
HOMEPAGE="https://qpdf.sourceforge.net/"
#SRC_URI="mirror://sourceforge/qpdf/${P}.tar.gz
#	doc? ( mirror://sourceforge/qpdf/${P}-doc.zip )"
# TODO: make SRC_URI generic
SRC_URI="https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.3.0cmake1/qpdf-10.6.3.0cmake1.tar.gz"
SRC_URI+=" doc? ( https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.6.3.0cmake1/qpdf-10.6.3.0cmake1-doc.zip )"

LICENSE="|| ( Apache-2.0 Artistic-2 )"
# subslot = libqpdf soname version
SLOT="0/28"
# Unkeyworded testing version for CMake
# Do not keyword -- qpdf 11 will be the first released version w/ CMake
# This version is for packagers to test.
# https://github.com/qpdf/qpdf/discussions/676
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~sparc-solaris"
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
		-DINSTALL_MANUAL=ON
	)

	if use ssl ; then
		local crypto_provider=$(usex gnutls GNUTLS OPENSSL)
		myconf+=(
			-DDEFAULT_CRYPTO=${crypto_provider}
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
