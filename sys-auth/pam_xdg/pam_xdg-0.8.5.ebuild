# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam toolchain-funcs

DESCRIPTION="PAM module that manages XDG Base Directories"
HOMEPAGE="https://www.sdaoden.eu/code.html https://www.sdaoden.eu/code-pam_xdg.html"
SRC_URI="https://ftp.sdaoden.eu/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64"

RDEPEND="sys-libs/pam"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC

	# Do we want to set XDG_CONFIG_DIR for prefix?
	emake \
		CFLAGS="${CFLAGS} -DNDEBUG" \
		LDFLAGS="-shared -fPIC ${LDFLAGS}" \
		PREFIX="${EPREFIX}" \
		LIBDIR="${EPREFIX}$(getpam_mod_dir)"
}

src_install() {
	dopammod pam_xdg.so
	doman pam_xdg.8
}
