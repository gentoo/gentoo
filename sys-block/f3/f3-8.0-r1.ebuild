# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Utilities to detect broken or counterfeit flash storage"
HOMEPAGE="https://github.com/AltraMayor/f3"

if [[ ${PV} == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/AltraMayor/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/AltraMayor/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="extra"

RDEPEND="elibc_musl? ( sys-libs/argp-standalone )"
DEPEND="${RDEPEND}
	extra? (
		sys-block/parted
		virtual/udev
	)"

DOCS=( changelog README.rst )

src_prepare() {
	default

	sed -i \
		-e 's:-ggdb::' \
		-e 's:^PREFIX =:PREFIX ?=:' \
		Makefile || die

	# bug #715518
	use elibc_musl && append-ldflags -largp

	tc-export CC
}

src_compile() {
	default

	if use extra; then
		emake V=1 extra
	fi
}

src_install() {
	emake PREFIX="${ED}/usr" install

	if use extra; then
		emake PREFIX="${ED}/usr" install-extra
	fi

	einstalldocs
}
