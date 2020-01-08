# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fuse-filesystem utilizing the sftp service"
HOMEPAGE="https://github.com/libfuse/sshfs"
SRC_URI="https://github.com/libfuse/${PN}/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 arm ~arm64 hppa ~ppc ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"
SLOT="0"

CDEPEND=">=sys-fs/fuse-2.6.0_pre3:0
	>=dev-libs/glib-2.4.2"
RDEPEND="${CDEPEND}
	>=net-misc/openssh-4.4"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
