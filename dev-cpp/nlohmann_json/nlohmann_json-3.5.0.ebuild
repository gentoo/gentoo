# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="JSON for Modern C++"
HOMEPAGE="https://github.com/nlohmann/json https://nlohmann.github.io/json/"
SRC_URI="https://github.com/nlohmann/json/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc"

DEPEND="doc? ( app-doc/doxygen )"

DOCS=( ChangeLog.md README.md )

S=${WORKDIR}/json-${PV}

src_compile() {
	meson_src_compile
	use doc && emake -C doc
}

src_test() {
	emake check
}

src_install() {
	meson_src_install
	use doc && dodoc -r doc/html
}
