# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

REMAKE_COMMIT="ff799578de24cf4be6ec230702ff5f978432ca51"
DESCRIPTION="Patched dev-build/remake for dev-build/parmasan, a parallel make sanitizer"
HOMEPAGE="https://github.com/ispras/parmasan-remake"
SRC_URI="https://github.com/ispras/parmasan-remake/archive/${REMAKE_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}"/${PN}-${REMAKE_COMMIT}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="readline"

# Test failures caused by '--parmasan-strategy' appearing which is the point
# of the project. The tests could possibly be adapted but aren't right now.
RESTRICT="test"

RDEPEND="
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Fixed in upstream gnulib but not yet propagated into make (bug #938934)
	append-cflags -std=gnu17
	# Fixed in upstream make/gnulib, just not yet propagated into remake (bug #863827)
	filter-lto

	use readline || export vl_cv_lib_readline=no

	local myeconfargs=(
		--without-guile
		--disable-nls

		--with-make-name=${PN}
		# parmasan doesn't support it, turn it off
		# https://github.com/ispras/parmasan?tab=readme-ov-file#building
		--disable-posix-spawn

		# Fails to install w/ 'make.texi:5: @include: could not find version.texi'
		MAKEINFO=:
	)

	econf "${myeconfargs[@]}"

}

src_install() {
	default

	# Avoid collision with dev-build/remake, not that parmasan seems
	# to need this file anyway.
	mv "${ED}"/usr/include/gnuremake.h "${ED}"/usr/include/gnuparmasan-remake.h || die
}
