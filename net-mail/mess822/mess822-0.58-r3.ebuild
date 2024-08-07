# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Collection of utilities for parsing Internet mail messages"
HOMEPAGE="https://cr.yp.to/mess822.html"
SRC_URI="
	https://cr.yp.to/software/${P}.tar.gz
	https://dev.gentoo.org/~arkamar/distfiles/${P}-modern-compilers.patch.xz
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RESTRICT="test"

RDEPEND="sys-apps/sed"

PATCHES=(
	"${WORKDIR}/${P}-modern-compilers.patch"
)

src_prepare() {
	default

	echo "$(tc-getCC) ${CFLAGS}" > conf-cc || die
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld || die
	echo "/usr" > conf-home || die

	local sed_args=(
		-e "s:ar:$(tc-getAR):"
		-e "s:ranlib:$(tc-getRANLIB):"
	)
	sed -i "${sed_args[@]}" make-makelib.sh || die "sed make-makelib.sh failed"
}

src_install() {
	dodir /etc
	dodir /usr/share

	# Now that the commands are compiled, update the conf-home file to point
	# to the installation image directory.
	echo "${ED}/usr/" > conf-home || die

	local sed_args=(
		-e "s:\"/etc\":\"${ED}/etc\":"
		-e "s:lib:$(get_libdir):"
		-e "s:man:share/man:"
	)
	sed -i "${sed_args[@]}" hier.c || die "sed hier.c failed"

	emake setup

	einstalldocs
}
