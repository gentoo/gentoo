# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="C++ classes for flexible logging to files, syslog and other destinations"
HOMEPAGE="https://log4cpp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1"
SLOT="0/5"
KEYWORDS="amd64 ~arm ppc ~riscv ~s390 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/1.0-doc_install_path.patch
	"${FILESDIR}"/1.0-gcc43.patch
	"${FILESDIR}"/1.0-asneeded.patch
	"${FILESDIR}"/${PN}-1.1-cmath-fix.patch
	"${FILESDIR}"/${PN}-1.1-automake-1.13.patch
	"${FILESDIR}"/${PN}-1.1-glibc-2.31.patch
	"${FILESDIR}"/${PN}-1.1.3-fix-version.patch
	"${FILESDIR}"/${PN}-1.1.3-fix-implicit-func-in-configure.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# Build tests conditionally
	if ! use test; then
		sed -i -e '/^SUBDIRS/s/ tests//' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	append-cxxflags -Wno-register # https://bugs.gentoo.org/895054
	# Bashisms call configure tests to malfunction / config.h to be misgenerated
	# which then causes a build failure later on in the package (w/ GCC 12,
	# anyway).
	CONFIG_SHELL="${BROOT}"/bin/bash econf \
		--without-idsa \
		$(use_enable doc doxygen)
}

src_install() {
	default

	# Package installs .pc files
	find "${ED}" -name '*.la' -delete || die
}
