# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="System for sequential logic synthesis and formal verification"
HOMEPAGE="https://people.eecs.berkeley.edu/~alanmi/abc/
	https://github.com/berkeley-abc/abc/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/berkeley-abc/abc.git"
elif [[ ${PV} == *_p20230313 ]] ; then
	COMMIT=a5f4841486d4a491913943c5b92167a9e988abac
	SRC_URI="https://github.com/berkeley-abc/abc/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/abc-${COMMIT}
	KEYWORDS="~amd64 ~x86"
else
	die "unsupported abc version, given: ${PV}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="+readline +threads"

RDEPEND="readline? ( sys-libs/readline:= )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/abc-0_p20230313-libabc.patch )

src_compile() {
	local -a mymakeargs=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		LD="$(tc-getCXX)"
		ABC_MAKE_VERBOSE=1
		ABC_USE_NO_CUDD=1
		ABC_USE_PIC=1
		$(usex readline "ABC_USE_READLINE=1" "ABC_USE_NO_READLINE=1")
		$(usex threads "ABC_USE_PTHREADS=1" "ABC_USE_NO_PTHREADS=1")
	)
	emake "${mymakeargs[@]}" libabc.so
	emake "${mymakeargs[@]}" abc
}

src_install() {
	exeinto /usr/bin
	doexe abc

	newlib.so libabc.so libabc.so.0
	dosym -r /usr/$(get_libdir)/libabc.so.0 /usr/$(get_libdir)/libabc.so

	dodoc README.md readmeaig
}
