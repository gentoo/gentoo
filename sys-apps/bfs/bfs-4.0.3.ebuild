# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo flag-o-matic toolchain-funcs

DESCRIPTION="Breadth-first version of the UNIX find command"
HOMEPAGE="https://tavianator.com/projects/bfs.html"
SRC_URI="https://github.com/tavianator/bfs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="0BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc"
IUSE="acl caps debug io-uring selinux unicode"

DEPEND="
	acl? ( virtual/acl )
	caps? ( sys-libs/libcap )
	io-uring? ( sys-libs/liburing:= )
	selinux? ( sys-libs/libselinux )
	unicode? ( dev-libs/oniguruma:= )
"
RDEPEND="${DEPEND}"

QA_CONFIG_IMPL_DECL_SKIP=(
	# Not available on Linux
	acl_is_trivial_np acl_trivial fdclosedir getdents getprogname
	posix_spawn_file_actions_addfchdir getmntinfo posix_getdents strtofflags
	# Seems to be in POSIX 2024 but not yet in ncurses?
	tcgetwinsize
)

src_configure() {
	tc-export CC PKG_CONFIG
	use debug || append-cppflags -DNDEBUG

	edo ./configure \
		$(use_with acl libacl) \
		$(use_with caps libcap) \
		$(use_with selinux libselinux) \
		$(use_with io-uring liburing) \
		$(use_with unicode oniguruma) \
		V=1
}

src_compile() {
	emake V=1
}

src_test() {
	# -n check gets confused so need manual src_test definition?
	emake V=1 check
}

src_install() {
	emake V=1 DESTDIR="${D}" install
	einstalldocs
}
