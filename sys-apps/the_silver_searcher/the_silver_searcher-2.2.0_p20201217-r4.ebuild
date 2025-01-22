# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 flag-o-matic vcs-snapshot

COMMIT="a61f1780b64266587e7bc30f0f5f71c6cca97c0f"
DESCRIPTION="A code-searching tool similar to ack, but faster"
HOMEPAGE="https://github.com/ggreer/the_silver_searcher"
SRC_URI="https://github.com/ggreer/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~x86 ~amd64-linux ~x64-macos"
IUSE="lzma test zlib"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libpcre
	lzma? ( app-arch/xz-utils )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? (
		dev-util/cram
		dev-vcs/git
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.1.0-lzma.patch
	"${FILESDIR}"/${PN}-2.2.0-no_lfs64.patch
	"${FILESDIR}"/${PN}-2.2.0-lfs-fixup-config.patch
	# https://github.com/ggreer/the_silver_searcher/issues/1537
	# broken with >=app-shells/bash-completion-2.12
	"${FILESDIR}"/0001-bash-completion-port-to-v2-API.patch
)

src_prepare() {
	default

	sed '/^dist_bashcomp/d' -i Makefile.am || die

	eautoreconf
}

src_configure() {
	# false positive TEXTRELs on riscv
	# https://bugs.gentoo.org/797355
	append-flags -fPIC

	econf \
		$(use_enable lzma) \
		$(use_enable zlib)
}

src_test() {
	cram -v tests/*.t || die "tests failed"
}

src_install() {
	default
	newbashcomp ag.bashcomp.sh ag
}
