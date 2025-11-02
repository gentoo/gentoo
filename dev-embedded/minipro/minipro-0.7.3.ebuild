# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs udev

DESCRIPTION="A program for controlling the MiniPRO TL866xx series of chip programmers"
HOMEPAGE="https://gitlab.com/DavidGriffith/minipro/"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://gitlab.com/DavidGriffith/minipro.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/DavidGriffith/minipro/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DEPEND="
	virtual/libusb:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_compile()
{
	emake CC=$(tc-getCC) PREFIX="${EPREFIX}/usr" COMPLETIONS_DIR="$(get_bashcompdir)"
}

src_install()
{
	emake CC=$(tc-getCC) DESTDIR="${D}" PREFIX="${EPREFIX}/usr" COMPLETIONS_DIR="$(get_bashcompdir)" install
}

pkg_postinst()
{
	udev_reload
}

pkg_postrm()
{
	udev_reload
}
