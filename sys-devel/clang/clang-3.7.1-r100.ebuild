# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit multilib-build

DESCRIPTION="C language family frontend for LLVM (meta-ebuild)"
HOMEPAGE="http://clang.llvm.org/"
SRC_URI=""

LICENSE="UoI-NCSA"
SLOT="0/3.7"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="debug multitarget python +static-analyzer"

RDEPEND="~sys-devel/llvm-${PV}[clang(-),debug=,multitarget?,python?,static-analyzer,${MULTILIB_USEDEP}]"

# Please keep this package around since it's quite likely that we'll
# return to separate LLVM & clang ebuilds when the cmake build system
# is complete.

pkg_postinst() {
	if has_version ">=dev-util/ccache-3.1.9-r2" ; then
		#add ccache links as clang might get installed after ccache
		"${EROOT}"/usr/bin/ccache-config --install-links
	fi
}

pkg_postrm() {
	if has_version ">=dev-util/ccache-3.1.9-r2" && [[ -z ${REPLACED_BY_VERSION} ]]; then
		# --remove-links would remove all links, --install-links updates them
		"${EROOT}"/usr/bin/ccache-config --install-links
	fi
}
