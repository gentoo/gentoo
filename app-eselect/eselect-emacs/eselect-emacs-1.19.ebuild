# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eapi9-ver

DESCRIPTION="Manage multiple Emacs versions on one system"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Emacs"
SRC_URI="https://dev.gentoo.org/~ulm/emacs/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND=">=app-admin/eselect-1.2.6
	~app-eselect/eselect-ctags-${PV}"

src_compile() { :; }

src_install() {
	insinto /usr/share/eselect/modules
	doins {emacs,gnuclient}.eselect
	doman {emacs,gnuclient}.eselect.5
	dodoc ChangeLog
}

pkg_postinst() {
	if ver_replacing -lt 1.19; then
		# Refresh, 1.19 introduced a symlink in /usr/include
		local target=$(eselect --brief emacs show)
		[[ ${target// } == emacs* ]] && eselect emacs set "${target// }"
	fi
}
