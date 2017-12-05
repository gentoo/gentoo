# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Hybrid between a make utility and a shell scripting language"
HOMEPAGE="https://fbb-git.github.io/icmake/ https://github.com/fbb-git/icmake"
SRC_URI="https://github.com/fbb-git/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${P}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-9.00.00-ar.patch
	"${FILESDIR}"/${PN}-9.02.02-verbose-build.patch
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
	./icm_prepare "${EROOT}" || die
}

src_compile() {
	./icm_bootstrap "${EROOT}" || die
}

src_install() {
	./icm_install all "${ED}" || die
}
