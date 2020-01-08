# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utilities to detect broken or counterfeit flash storage"
HOMEPAGE="http://oss.digirati.com.br/f3/ https://github.com/AltraMayor/f3"

PATCHES=(
)

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/AltraMayor/${PN}.git"

	PATCHES=()

	inherit git-r3
else
	SRC_URI="https://github.com/AltraMayor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

IUSE="extra"

DEPEND="extra? (
		sys-block/parted
		virtual/udev
	)"

RDEPEND=""

DOCS=( changelog README.rst )

src_prepare() {
	default

	sed -i \
		-e 's:-ggdb::' \
		-e 's:^PREFIX =:PREFIX ?=:' \
		Makefile || die

	tc-export CC
}

src_compile() {
	default

	if use extra; then
		emake V=1 extra
	fi
}

src_install() {
	emake PREFIX="${ED%/}/usr" install

	if use extra; then
		emake PREFIX="${ED%/}/usr" install-extra
	fi

	einstalldocs
}
