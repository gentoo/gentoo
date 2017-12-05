# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools ltprune multilib-minimal

MY_P="onig-${PV}"

DESCRIPTION="a regular expression library for different character encodings"
HOMEPAGE="https://github.com/kkos/oniguruma"
SRC_URI="https://github.com/kkos/${PN}/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/4" # sub-slot matches SONAME major
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"
IUSE="combination-explosion-check crnl-as-line-terminator static-libs"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-combination-explosion-check.patch
)
DOCS=( AUTHORS HISTORY README{,.ja} doc/. )

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable combination-explosion-check) \
		$(use_enable crnl-as-line-terminator) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
