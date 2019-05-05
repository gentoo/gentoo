# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="A somewhat comprehensive collection of Italian Linux man pages"
HOMEPAGE="http://it.tldp.org/man/"
SRC_URI="ftp://ftp.pluto.it/pub/pluto/ildp/man/${P}.tar.xz"

LICENSE="man-pages GPL-2+ BSD MIT FDL-1.1+ public-domain man-pages-posix"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 ~riscv s390 sh sparc x86"
IUSE=""

RDEPEND="virtual/man"

src_compile() { :; } # emake does bad things here

src_install() {
	doman -i18n=it man-pages/man[1-9]/* binutils/man[1-9]/* inetutils/man[1-9]/* \
		util-linux/man[1-9]/* misc/man[1-9]/*

	dodoc description README CHANGELOG
}
