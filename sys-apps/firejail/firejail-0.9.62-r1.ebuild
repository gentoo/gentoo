# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~x86"
	SRC_URI="https://github.com/netblue30/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
else
	inherit git-r3
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	EGIT_BRANCH="master"
fi

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"

LICENSE="GPL-2"
SLOT="0"
IUSE="apparmor +chroot contrib debug +file-transfer +globalcfg +network +overlayfs +private-home +seccomp +suid test +userns vim-syntax +whitelist x11"
RESTRICT="!test? ( test )"

RDEPEND="apparmor? ( sys-libs/libapparmor )"

DEPEND="${RDEPEND}
	!sys-apps/firejail-lts
	test? ( dev-tcltk/expect )"


src_prepare() {
	default

	find ./contrib -type f -name '*.py' | xargs sed --in-place 's-#!/usr/bin/python3-#!/usr/bin/env python3-g' || die

	find -type f -name Makefile.in | xargs sed -i -r \
			-e '/^\tinstall .*COPYING /d' \
			-e '/CFLAGS/s: (-O2|-ggdb) : :g' || die

	sed -i -r -e '/CFLAGS/s: (-O2|-ggdb) : :g' ./src/common.mk.in || die

	# remove compression of man pages
	sed -i -e '/gzip -9n $$man; \\/d' Makefile.in || die
	sed -i -e '/rm -f $$man.gz; \\/d' Makefile.in || die
	sed -i -r -e 's|\*\.([[:digit:]])\) install -c -m 0644 \$\$man\.gz|\*\.\1\) install -c -m 0644 \$\$man|g' Makefile.in || die
}

src_configure() {
	econf \
		--disable-firetunnel \
		$(use_enable apparmor) \
		$(use_enable chroot) \
		$(use_enable contrib contrib-install) \
		$(use_enable file-transfer) \
		$(use_enable globalcfg) \
		$(use_enable network) \
		$(use_enable overlayfs) \
		$(use_enable private-home) \
		$(use_enable seccomp) \
		$(use_enable suid) \
		$(use_enable userns) \
		$(use_enable whitelist) \
		$(use_enable x11)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	default

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/ftdetect
		doins contrib/vim/ftdetect/firejail.vim

		insinto /usr/share/vim/vimfiles/syntax
		doins contrib/vim/syntax/firejail.vim
	fi
}
