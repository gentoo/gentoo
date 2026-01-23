# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Advanced CLI tool for sending email"
HOMEPAGE="https://github.com/deanproxy/eMail"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.3-fno-common.patch
	"${FILESDIR}"/${PN}-3.1.3-fix-clang16-configure.patch
	"${FILESDIR}"/${PN}-3.1.3-fix_c23.patch
	"${FILESDIR}"/${PN}-3.1.3-ar_call.patch
)

src_prepare() {
	default
	# dlib/configure.in patched to use AR
	pushd dlib >/dev/null || die
	eautoconf
	popd >/dev/null || die
}

src_configure() {
	tc-export AR CC
	default
}

src_install() {
	default
	doman email.1

	# remove duplicate man/docs
	rm -r "${ED}"/usr/share/doc/${PF}/${P} || die
}
