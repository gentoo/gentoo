# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Breadth-first version of the UNIX find command"
HOMEPAGE="https://tavianator.com/projects/bfs.html"
SRC_URI="https://github.com/tavianator/bfs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc"
IUSE="acl caps debug io-uring unicode xattr"

DEPEND="
	acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	io-uring? ( sys-libs/liburing:= )
	unicode? ( dev-libs/oniguruma:= )
	xattr? ( sys-apps/attr )
"
RDEPEND="${DEPEND}"

bfsmake() {
	emake \
		USE_ACL=$(usev acl '1') \
		USE_ATTR=$(usev xattr '1') \
		USE_LIBCAP=$(usev caps '1') \
		USE_LIBURING=$(usev io-uring '1') \
		USE_ONIGURUMA=$(usev unicode '1') \
		"$@"
}

src_compile() {
	tc-export CC
	use debug || append-cppflags -DNDEBUG

	bfsmake
}

src_test() {
	# -n check gets confused so need manual src_test definition?
	bfsmake check
}

src_install() {
	bfsmake DESTDIR="${D}" install
	einstalldocs
}
