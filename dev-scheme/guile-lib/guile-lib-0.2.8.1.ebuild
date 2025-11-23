# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# 2-2 could be made to work but a few tests fail and nobody seems
# to care about it (patches had no reply on ML).
GUILE_COMPAT=( 3-0 )
inherit guile

DESCRIPTION="An accumulation place for pure-scheme Guile modules"
HOMEPAGE="http://www.nongnu.org/guile-lib/"
SRC_URI="mirror://nongnu/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

REQUIRED_USE="${GUILE_REQUIRES_USE}"

RDEPEND="${GUILE_DEPS}"
DEPEND="${RDEPEND}"

src_prepare() {
	guile_src_prepare
	sed -i -e 's/"guile"/(getenv "GUILE")/' unit-tests/os.process.scm || die
	guile_copy_sources

	# Only apply this patch for 3.0 (bug #877785)
	if use guile_targets_3-0 ; then
		cd "${WORKDIR}"/${P}-3.0 || die
		eapply "${FILESDIR}"/${PN}-0.2.8.1-guile3-primes.patch
	fi
}

src_configure() {
	_guile_configure() {
		cd "${WORKDIR}"/${P}-${GUILE_CURRENT_VERSION} || die
		ECONF_SOURCE="${WORKDIR}"/${P}-${GUILE_CURRENT_VERSION}
		econf --with-guile-site=yes
	}

	guile_foreach_impl _guile_configure
}

src_compile() {
	_guile_compile() {
		cd "${WORKDIR}"/${P}-${GUILE_CURRENT_VERSION} || die
		sed -i -e "s:exec guile:exec ${GUILE}:" doc/make-texinfo.scm || die
		emake
	}

	guile_foreach_impl _guile_compile
}

src_test() {
	_guile_test() {
		cd "${WORKDIR}"/${P}-${GUILE_CURRENT_VERSION} || die
		emake check
	}

	guile_foreach_impl _guile_test
}

src_install() {
	_guile_install() {
		cd "${WORKDIR}"/${P}-${GUILE_CURRENT_VERSION} || die
		emake DESTDIR="${SLOTTED_D}" install
	}

	einstalldocs
	guile_foreach_impl _guile_install
	guile_merge_roots
	guile_unstrip_ccache
}
