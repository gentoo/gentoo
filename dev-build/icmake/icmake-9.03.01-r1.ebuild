# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Hybrid between a make utility and a shell scripting language"
HOMEPAGE="https://fbb-git.gitlab.io/icmake/ https://gitlab.com/fbb-git/icmake"
SRC_URI="https://gitlab.com/fbb-git/${PN}/-/archive/${PV}/${P}.tar.gz"
S="${WORKDIR}/${P}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-9.00.00-ar.patch
	"${FILESDIR}"/${PN}-9.02.02-verbose-build.patch
	"${FILESDIR}"/${PN}-9.03.01-compressed-docs.patch
	"${FILESDIR}"/${PN}-9.03.01-ar.patch
)

src_prepare() {
	default

	sed -e "/^#define LIBDIR/s/lib/$(get_libdir)/" \
		-e "/^#define DOCDIR/s/${PN}/${PF}/" \
		-e "/^#define DOCDOCDIR/s/${PN}-doc/${PF}/" \
		-i INSTALL.im || die

	# fix build issues (bug #589896)
	append-cflags -std=gnu99

	tc-export AR CC
}

src_configure() {
	./icm_prepare "${EPREFIX}" || die
}

src_compile() {
	./icm_bootstrap "${EPREFIX}" || die
}

src_install() {
	./icm_install all "${D}" || die
}
