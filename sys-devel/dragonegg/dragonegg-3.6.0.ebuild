# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib toolchain-funcs

DESCRIPTION="GCC plugin that uses LLVM for optimization and code generation"
HOMEPAGE="http://dragonegg.llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
	test? ( http://llvm.org/releases/${PV}/llvm-${PV}.src.tar.xz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="test"

DEPEND=">=sys-devel/gcc-4.5:*
	=sys-devel/llvm-${PV}*"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P}.src

pkg_pretend() {
	# Bug #511640: gcc 4.9 removed a required header
	if [[ ${MERGE_TYPE} != binary ]]; then
		[[ $(gcc-version) > 4.8 || $(gcc-version) < 4.5 ]] && \
			die 'The active compiler needs to be gcc 4.[5-8])'
	fi
}

src_compile() {
	# GCC: compiler to use plugin with
	emake CC="$(tc-getCC)" GCC="$(tc-getCC)" CXX="$(tc-getCXX)" VERBOSE=1
}

src_test() {
	# GCC languages are determined via locale-dependant gcc -v output
	export LC_ALL=C

	emake LIT_DIR="${WORKDIR}"/llvm-${PV}.src/utils/lit check
}

src_install() {
	exeinto /usr/$(get_libdir)
	doexe dragonegg.so

	dodoc README
}

pkg_postinst() {
	elog "To use dragonegg, run gcc as usual, with an extra command line argument:"
	elog "	-fplugin=/usr/$(get_libdir)/dragonegg.so"
	elog "If you change the active gcc profile, or update gcc to a new version,"
	elog "you will have to remerge this package to update the plugin"
}
