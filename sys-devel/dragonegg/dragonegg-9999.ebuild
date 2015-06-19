# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-devel/dragonegg/dragonegg-9999.ebuild,v 1.8 2015/02/18 21:33:18 voyageur Exp $

EAPI=5
inherit git-r3 multilib toolchain-funcs

DESCRIPTION="GCC plugin that uses LLVM for optimization and code generation"
HOMEPAGE="http://dragonegg.llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/dragonegg.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=sys-devel/gcc-4.5:*
	~sys-devel/llvm-${PV}"
RDEPEND="${DEPEND}"

src_unpack() {
	if has test $FEATURES
	then
		EGIT_REPO_URI="http://llvm.org/git/llvm.git" EGIT_CHECKOUT_DIR="${WORKDIR}/llvm" git-r3_src_unpack
	fi
	git-r3_src_unpack
}

src_compile() {
	# GCC: compiler to use plugin with
	emake CC="$(tc-getCC)" GCC="$(tc-getCC)" CXX="$(tc-getCXX)" VERBOSE=1
}

src_test() {
	# GCC languages are determined via locale-dependant gcc -v output
	export LC_ALL=C

	emake LIT_DIR="${WORKDIR}"/llvm/utils/lit check
}

src_install() {
	# Install plugin in llvm lib directory
	exeinto /usr/$(get_libdir)/llvm
	doexe dragonegg.so

	dodoc README
}

pkg_postinst() {
	elog "To use dragonegg, run gcc as usual, with an extra command line argument:"
	elog "	-fplugin=/usr/$(get_libdir)/llvm/dragonegg.so"
	elog "If you change the active gcc profile, or update gcc to a new version,"
	elog "you will have to remerge this package to update the plugin"
}
