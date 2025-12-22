# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Foreign function interface for bash"
HOMEPAGE="https://github.com/taviso/ctypes.sh"

MY_COMMIT_ID="62ec33a6688a29eefdc141f21784193677ba76dc"
SRC_URI="
	https://github.com/taviso/${PN/-/.}/archive/${MY_COMMIT_ID}.tar.gz
		-> ${P}.tar.gz
	https://github.com/taviso/ctypes.sh/commit/35ae591664ca3deb624fae9bbbd398b5927aba1a.patch
		-> ${PN}-1.2-fix-incompatible-pointer-types.patch
"

S="${WORKDIR}/${PN/-/.}-${MY_COMMIT_ID}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-shells/bash:=[plugins(-)]
	dev-libs/libffi:=
	virtual/libelf:=
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# https://github.com/taviso/ctypes.sh/pull/64/
	"${DISTDIR}"/${PN}-1.2-fix-incompatible-pointer-types.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}

src_test() {
	cd test || die

	# Tests require non-striped libs
	local -x BASH_LOADABLES_PATH="${S}/src/.libs"
	emake CC="$(tc-getCC)"
}
