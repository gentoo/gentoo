# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Open source implementation of Object Rexx"
HOMEPAGE="https://www.oorexx.org/
	https://sourceforge.net/projects/oorexx/"

if [[ "${PV}" == *_beta* ]] ; then
	REL="beta"
else
	REL=""
fi

REL_V="$(ver_cut 1-3)"
APP_P="${P/_beta/-}"

SRC_URI="https://downloads.sourceforge.net/project/${PN}/${PN}/${REL_V}${REL}/${APP_P}.tar.gz"
S="${WORKDIR}/${APP_P}"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~riscv ~x86"

RDEPEND="
	!dev-lang/regina-rexx
	sys-libs/ncurses:=
	virtual/libcrypt:=
"
DEPEND="
	${RDEPEND}
"

PATCHES=(
	"${FILESDIR}/oorexx-5.0.0-cmake_minimum_required.patch"
	"${FILESDIR}/oorexx-5.0.0-man.patch"
)

src_prepare() {
	find ./samples/ -type f -iname "CMakeLists.txt" -exec sed -i {} \
		-e "/cmake_minimum_required/I s|(.*)|(VERSION 3.20)|g"  \
		-e "/cmake_policy.*/d" \; \
		|| die

	cmake_src_prepare
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/952966
	# https://sourceforge.net/p/oorexx/bugs/2029/
	#
	# Do not trust LTO either
	append-flags -fno-strict-aliasing
	filter-lto

	# bug 924171
	if use elibc_musl ; then
		append-cppflags -D_LARGEFILE64_SOURCE
	fi

	cmake_src_configure
}
