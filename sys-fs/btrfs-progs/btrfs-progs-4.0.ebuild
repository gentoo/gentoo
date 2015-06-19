# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/btrfs-progs/btrfs-progs-4.0.ebuild,v 1.1 2015/05/09 23:23:01 floppym Exp $

EAPI=5

inherit bash-completion-r1 eutils multilib toolchain-funcs

libbtrfs_soname=0

if [[ ${PV} != 9999 ]]; then
	MY_PV=v${PV}
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
	SRC_URI="https://www.kernel.org/pub/linux/kernel/people/kdave/${PN}/${PN}-${MY_PV}.tar.xz"
	S="${WORKDIR}"/${PN}-${MY_PV}
else
	WANT_LIBTOOL=none
	inherit autotools git-r3
	EGIT_REPO_URI="git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
		https://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git"
fi

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="https://btrfs.wiki.kernel.org"

LICENSE="GPL-2"
SLOT="0/${libbtrfs_soname}"
IUSE="+convert"

RESTRICT=test # tries to mount repared filesystems

RDEPEND="
	dev-libs/lzo:2=
	sys-libs/zlib:0=
	convert? (
		sys-fs/e2fsprogs:0=
		sys-libs/e2fsprogs-libs:0=
	)
"
DEPEND="${RDEPEND}
	convert? ( sys-apps/acl )
	app-text/asciidoc
	app-text/docbook-xml-dtd:4.5
	app-text/xmlto
"

if [[ ${PV} == 9999 ]]; then
	DEPEND+=" sys-devel/gnuconfig"
fi

src_prepare() {
	epatch_user
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
		mkdir config || die
		local automakedir="$(autotools_run_tool --at-output automake --print-libdir)"
		[[ -e ${automakedir} ]] || die "Could not locate automake directory"
		ln -s "${automakedir}"/install-sh config/install-sh || die
		ln -s "${EPREFIX}"/usr/share/gnuconfig/config.guess config/config.guess || die
		ln -s "${EPREFIX}"/usr/share/gnuconfig/config.sub config/config.sub || die
	fi
}

src_configure() {
	local myeconfargs=(
		--bindir="${EPREFIX}"/sbin
		$(use_enable convert)
		$(use_enable elibc_glibc backtrace)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake V=1
}

src_install() {
	default
	newbashcomp btrfs-completion btrfs
}
