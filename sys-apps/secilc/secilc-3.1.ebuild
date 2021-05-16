# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit toolchain-funcs

MY_P="${P//_/-}"
MY_RELEASEDATE="20200710"

SEPOL_VER="${PV}"

DESCRIPTION="SELinux Common Intermediate Language (CIL) Compiler"
HOMEPAGE="https://github.com/SELinuxProject/selinux/wiki"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SELinuxProject/selinux.git"
	S="${WORKDIR}/${MY_P}/${PN}"
else
	SRC_URI="https://github.com/SELinuxProject/selinux/releases/download/${MY_RELEASEDATE}/${MY_P}.tar.gz"
	KEYWORDS="amd64 x86"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"

DEPEND=">=sys-libs/libsepol-${SEPOL_VER}"
RDEPEND="${DEPEND}"
BDEPEND="app-text/xmlto"

# tests are not meant to be run outside of the
# full SELinux userland repo
RESTRICT="test"

src_compile() {
	tc-export CC
	default
}
