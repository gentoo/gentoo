# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/btrfs-progs/btrfs-progs-3.18.2.ebuild,v 1.2 2015/03/03 10:02:23 dlan Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

libbtrfs_soname=0

if [[ ${PV} != 9999 ]]; then
	MY_PV=v${PV}
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${PN}-${MY_PV}.tar.xz"
	S="${WORKDIR}"/${PN}-${MY_PV}
else
	inherit git-r3
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
		https://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git"
fi

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="https://btrfs.wiki.kernel.org"

LICENSE="GPL-2"
SLOT="0/${libbtrfs_soname}"
IUSE=""

RESTRICT=test # tries to mount repared filesystems

RDEPEND="
	dev-libs/lzo:2=
	sys-libs/zlib:0=
	sys-fs/e2fsprogs:0=
"
DEPEND="${RDEPEND}
	sys-apps/acl
	app-text/asciidoc
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
"

src_prepare() {
	epatch_user
}

src_compile() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		BUILD_VERBOSE=1
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		prefix=/usr \
		bindir=/sbin \
		libdir=/usr/$(get_libdir) \
		mandir=/usr/share/man
}
