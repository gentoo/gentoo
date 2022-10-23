# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Fuse-filesystem utilizing the sftp service"
HOMEPAGE="https://github.com/libfuse/sshfs"
SRC_URI="https://github.com/libfuse/${PN}/releases/download/${P}/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux"
SLOT="0"

DEPEND=">=sys-fs/fuse-3.1.0:3
	>=dev-libs/glib-2.4.2"
RDEPEND="${DEPEND}
	>=net-misc/openssh-4.4"
BDEPEND="dev-python/docutils
	virtual/pkgconfig"

# requires root privs and specific localhost sshd setup
RESTRICT="test"

DOCS=( AUTHORS ChangeLog.rst README.rst )
