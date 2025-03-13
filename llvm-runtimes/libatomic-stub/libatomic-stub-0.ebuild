# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Stub library which allows compiler-rt to replace libatomic"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	llvm-runtimes/compiler-rt[atomic-builtins(-)]
	!sys-devel/gcc
"

src_install() {
	# Create an empty library, so that -latomic will not fail.
	# The atomic routines will be provided implicitly by the compiler-rt
	# builtins library.
	${AR} rc libatomic.a || die
	dolib.a libatomic.a
}
