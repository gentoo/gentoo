# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use (Qt6 bindings)"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"

# keep slot and keywords in sync with app-crypt/gpgme
LICENSE="metapackage"
SLOT="1/11.6.15.2"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ~m68k ppc ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="~app-crypt/gpgme-${PV}:=[qt6]"
