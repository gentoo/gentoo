# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Scans for and fixes broken or messy symlinks"
HOMEPAGE="https://github.com/brandt/symlinks"
SRC_URI="https://github.com/brandt/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="symlinks"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ppc ppc64 ~sparc x86"
IUSE="static"

DOCS=( Readme.md )

src_prepare() {
	default
	# could be useful if being used to repair
	# symlinks that are preventing shared libraries from
	# functioning.
	use static && append-flags -static
	append-lfs-flags
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CPPFLAGS} ${CFLAGS} ${LDFLAGS}"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.8"
	einstalldocs
}
