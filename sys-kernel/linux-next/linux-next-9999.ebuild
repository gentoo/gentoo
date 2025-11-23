# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git -> linux-next-${P}.git"
EGIT_CLONE_TYPE="shallow"

DESCRIPTION="Linux kernel and patches aimed at the next kernel merge window"
HOMEPAGE="https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	eapply_user
}

src_compile() {
	:;
}

src_install() {
	dodir /usr/src/
	cp -R "${S}/" "${D}/usr/src/" || die "Install failed!"
}
