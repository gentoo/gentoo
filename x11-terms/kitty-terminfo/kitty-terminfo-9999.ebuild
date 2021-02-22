# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit python-any-r1 toolchain-funcs xdg git-r3

DESCRIPTION="Terminfo for kitty, an OpenGL-based terminal emulator"
HOMEPAGE="https://github.com/kovidgoyal/kitty"
EGIT_REPO_URI="https://github.com/kovidgoyal/kitty.git"

LICENSE="GPL-3"
SLOT="0"
IUSE="debug"

DEPEND="${PYTHON_DEPS}"

PATCHES=(
	"${FILESDIR}"/kitty-terminfo-setup-9999.patch
)

# kitty-terminfo is a split package from kitty that only installs the terminfo
# file. As tests are designed to be run with the whole package compiled they
# would fail in this case.
RESTRICT="test"

src_compile() {
	"${EPYTHON}" setup.py \
		--verbose $(usex debug --debug "") \
		--libdir-name $(get_libdir) \
		linux-terminfo || die "Failed to compile kitty."
}

src_install() {
	insinto /usr
	doins -r linux-package/*
}
