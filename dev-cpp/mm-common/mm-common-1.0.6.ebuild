# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit gnome.org python-any-r1 meson

DESCRIPTION="Build infrastructure and utilities for GNOME C++ bindings"
HOMEPAGE="https://gtkmm.gnome.org/ https://gitlab.gnome.org/GNOME/mm-common"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv sparc x86"

BDEPEND="${PYTHON_DEPS}"

src_prepare() {
	default

	# Include project version in docdir name
	sed -i -e "s:^install_docdir.*:& + '-' + meson.project_version():" meson.build || die
}
