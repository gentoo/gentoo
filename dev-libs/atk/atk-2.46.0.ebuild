# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="GTK+ & GNOME Accessibility Toolkit"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+introspection"

DEPEND=""
RDEPEND=">=app-accessibility/at-spi2-core-2.46.0[introspection?,${MULTILIB_USEDEP}]"
