# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P=${P/_}

DESCRIPTION="A fractal generator"
HOMEPAGE="https://www.fractint.org"
SRC_URI="https://www.fractint.org/ftp/current/linux/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="free-noncomm HPND public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXft
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-20.04p16-install-phase.patch"
)

src_compile() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/864759
	# Reported to developer list at
	# https://mailman.xmission.com/postorius/lists/fractdev.mailman.xmission.com/
	#
	# Do not trust for LTO either
	append-flags -fno-strict-aliasing
	filter-lto
	emake CC="$(tc-getCC)" AS="$(tc-getAS)" OPT="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${ED}/usr" install
}
