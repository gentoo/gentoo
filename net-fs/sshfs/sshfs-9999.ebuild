# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Fuse-filesystem utilizing the sftp service"
HOMEPAGE="https://github.com/libfuse/sshfs"
if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/libfuse/sshfs.git"
else
	SRC_URI="https://github.com/libfuse/${PN}/releases/download/${P}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
fi
LICENSE="GPL-2"
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
