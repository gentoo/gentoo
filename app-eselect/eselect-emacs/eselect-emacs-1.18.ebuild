# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Manage multiple Emacs versions on one system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~riscv ~s390 ~sh sparc x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

RDEPEND=">=app-admin/eselect-1.2.6
	~app-eselect/eselect-ctags-${PV}"

src_compile() { :; }

src_install() {
	insinto /usr/share/eselect/modules
	doins {emacs,gnuclient}.eselect
	doman {emacs,gnuclient}.eselect.5
	dodoc ChangeLog
}
