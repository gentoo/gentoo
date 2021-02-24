# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multiprocessing toolchain-funcs

CRYSTAL_MOLINILLO_PV=0.1.0
CRYSTAL_MOLINILLO_P=crystal-molinillo-${CRYSTAL_MOLINILLO_PV}

DESCRIPTION="Dependency manager for the Crystal language"
HOMEPAGE="https://github.com/crystal-lang/shards"
SRC_URI="
	https://github.com/crystal-lang/shards/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/crystal-lang/crystal-molinillo/archive/v${CRYSTAL_MOLINILLO_PV}.tar.gz -> ${CRYSTAL_MOLINILLO_P}.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>dev-lang/crystal-0.11.1[yaml]
"
RDEPEND="${DEPEND}"

RESTRICT=test # missing files in tarball

src_prepare() {
	default

	# bundle crystal-molinillo to bootstrap 'shards'
	mkdir -p lib || die
	ln -s ../../${CRYSTAL_MOLINILLO_P} lib/molinillo || die

	tc-export CC
}

src_compile() {
	emake release=1 FLAGS="--link-flags=\"${LDFLAGS}\" --verbose --threads $(makeopts_jobs)"
}

src_install() {
	dobin bin/${PN}
	dodoc README.md
}
