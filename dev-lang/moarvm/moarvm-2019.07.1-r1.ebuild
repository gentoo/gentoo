# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_PN="MoarVM"
if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/${MY_PN}/${MY_PN}.git"
	EGIT_SUBMODULES=( '*' '-3rdparty/libatomicops' '-3rdparty/libuv' )
	inherit git-r3
	KEYWORDS=""
	S="${WORKDIR}/${P}"
else
	SRC_URI="http://moarvm.org/releases/${MY_PN}-${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="A 6model-based VM for NQP and Rakudo Perl 6"
HOMEPAGE="http://moarvm.org"
LICENSE="Artistic-2"
SLOT="0"
IUSE="asan clang debug doc static-libs optimize ubsan"

RDEPEND="dev-libs/libatomic_ops
		>=dev-libs/libuv-1.26
		dev-lang/lua:=
		virtual/libffi"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	clang? ( >=sys-devel/clang-3.1 )
	dev-lang/perl"

DOCS=( CREDITS README.markdown )

# Tests are conducted via nqp
RESTRICT=test

src_prepare() {
	if [[ "${PV}" == "9999" ]]; then
		# Stupid upstream try to auto-fetch this themselves
		git rm -f 3rdparty/{libatomicops,libuv} ||
			die "Can't strip unused submodules"
	fi
	default
}

src_configure() {
	use doc && DOCS+=( docs/* )
	local prefix="${EPREFIX}/usr"
	local libdir="${EPREFIX}/usr/$(get_libdir)"
	einfo "--prefix '${prefix}'"
	einfo "--libdir '${libdir}'"
	local myconfigargs=(
		"--prefix" "${prefix}"
		"--has-libuv"
		"--has-libatomic_ops"
		"--has-libffi"
		"--libdir" "${libdir}"
		"--compiler" "$(usex clang clang gcc)"
		"$(usex asan        --asan)"
		"$(usex debug       --debug            --no-debug)"
		"$(usex optimize    --optimize=        --no-optimize)"
		"$(usex static-libs --static)"
		"$(usex ubsan       --ubsan)"
	)

	perl Configure.pl "${myconfigargs[@]}" moarshared || die
}
