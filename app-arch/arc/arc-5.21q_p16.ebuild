# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

MY_PV="${PV%%_p*}"
MY_P="${PN}-${MY_PV}"
PATCH_LEVEL="${PV##*_p}"

DESCRIPTION="Create & extract files from DOS .ARC files"
HOMEPAGE="https://arc.sourceforge.net"
SRC_URI="
	https://github.com/ani6al/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_P}.tar.gz
	mirror://debian/pool/main/a/arc/arc_${MY_PV}-${PATCH_LEVEL}.debian.tar.xz
"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

src_prepare() {
	PATCHES=(
		$(sed -e 's:^:../debian/patches/:' "${WORKDIR}"/debian/patches/series || die)

		"${FILESDIR}"/${PN}-5.21m-darwin.patch
	)

	default

	sed -i Makefile \
		-e 's/CFLAGS = $(OPT) $(SYSTEM)/CFLAGS += $(SYSTEM)/' \
		|| die "sed Makefile"
}

src_compile() {
	# bug #940242
	filter-lto

	emake CC="$(tc-getCC)" OPT="${LDFLAGS}"
}

src_install() {
	dobin arc marc
	doman arc.1
	dodoc Arc521.doc Arcinfo Changelog Readme
}
