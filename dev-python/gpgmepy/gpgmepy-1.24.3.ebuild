# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit python-r1

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use (Python bindings)"
HOMEPAGE="https://www.gnupg.org/related_software/gpgme"

# keep slot and keywords in sync with app-crypt/gpgme
LICENSE="metapackage"
SLOT="1/11.6.15.2"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	~app-crypt/gpgme-${PV}:=[python,${PYTHON_USEDEP}]
"
