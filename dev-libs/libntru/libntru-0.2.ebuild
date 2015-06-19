# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libntru/libntru-0.2.ebuild,v 1.1 2014/04/16 22:48:09 hasufell Exp $

EAPI=5

inherit eutils toolchain-funcs multilib multilib-minimal

DESCRIPTION="C Implementation of NTRUEncrypt"
HOMEPAGE="https://github.com/tbuktu/libntru"
SRC_URI="https://github.com/tbuktu/libntru/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/01-${P}-fix-build-on-macosx.patch \
		"${FILESDIR}"/02-${P}-add-warnings.patch \
		"${FILESDIR}"/03-${P}-install-rules.patch \
		"${FILESDIR}"/04-${P}-respect-flags.patch \
		"${FILESDIR}"/05-${P}-fix-memory-leak.patch

	multilib_copy_sources
}

multilib_src_compile() {
	emake CC="$(tc-getCC)"
}

multilib_src_install() {
	emake \
		DESTDIR="${ED}" \
		INST_LIBDIR="/usr/$(get_libdir)" \
		INST_DOCDIR="/usr/share/doc/${PF}" \
		install
}
