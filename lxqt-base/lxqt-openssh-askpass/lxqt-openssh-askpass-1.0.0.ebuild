# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="LXQt OpenSSH user password prompt tool"
HOMEPAGE="https://lxqt-project.org/"

MY_PV="$(ver_cut 1-2)"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lxqt/${PN}.git"
else
	SRC_URI="https://github.com/lxqt/${PN}/releases/download/${PV}/${P}.tar.xz"
	KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"
fi

LICENSE="LGPL-2.1 LGPL-2.1+"
SLOT="0"

BDEPEND="
	>=dev-qt/linguist-tools-5.15:5
"
DEPEND="
	>=dev-qt/qtcore-5.15:5
	>=dev-qt/qtwidgets-5.15:5
	=lxqt-base/liblxqt-${MY_PV}*:=
"
RDEPEND="${DEPEND}"

src_install() {
	cmake_src_install
	doman man/*.1

	newenvd - 99${PN} <<- _EOF_
		SSH_ASKPASS='${EPREFIX}/usr/bin/lxqt-openssh-askpass'
	_EOF_
}
