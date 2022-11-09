# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="Format agnostic jQ"
HOMEPAGE="https://github.com/jzelinskie/faq"
SRC_URI="https://github.com/jzelinskie/faq/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-misc/jq
	dev-libs/oniguruma:="

DOCS=( README.md docs/examples.md )

QA_FLAGS_IGNORED="usr/bin/faq"
QA_PRESTRIPPED="usr/bin/faq"

src_compile() {
	emake FAQ_VERSION="${PV}" build
}

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}" bindir="/usr/bin" install

	einstalldocs
}
