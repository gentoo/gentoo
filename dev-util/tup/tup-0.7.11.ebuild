# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info toolchain-funcs

DESCRIPTION="File-based build system"
HOMEPAGE="https://gittup.org/tup/ https://github.com/gittup/tup"
# Tup itself is GPLv2, but it bundles differently licensed software:
# - lua: MIT
# - sqlite (unused in this ebuild): public domain
# - inih: 3-clause BSD
# - red-black tree implementation: 2-clause BSD
# - queue implementation: 3-clause BSD
LICENSE="GPL-2 MIT public-domain BSD BSD-2"
SLOT="0"

if [[ "${PV}" == 9999 ]]; then
	EGIT_REPO_URI="https://github.com/gittup/tup.git"
	inherit git-r3
else
	SRC_URI="https://github.com/gittup/tup/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
fi

DEPEND="
	dev-db/sqlite
	dev-libs/libpcre
	sys-fs/fuse:3
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

CONFIG_CHECK="~FUSE_FS ~NAMESPACES"
WARNING_FUSE_FS="CONFIG_FUSE_FS is required for tup to work"
WARNING_NAMESPACES="CONFIG_NAMESPACES is required for tup to work as intended (workaround: set TUP_NO_NAMESPACING env var when running tup)"

src_prepare() {
	# Use our toolchain
	sed -i Tuprules.tup \
		-e "s|CC = gcc|CC = $(tc-getCC) ${CFLAGS} ${LDFLAGS}|" \
		-e "s|ar crs|$(tc-getAR) crs|" || die

	if [[ ${PV} != 9999 ]]; then
		# Avoid invoking `git` to find version, use ours
		sed -i src/tup/link.sh \
			-e 's|`git describe`|v'"${PV}|" || die
	fi

	echo "CONFIG_TUP_USE_SYSTEM_SQLITE=y" >> tup.config

	default
}

src_compile() {
	# Disabling namespacing because it leads to accessing /proc/<pid>/setgroups
	# which violates sandboxing.
	export TUP_NO_NAMESPACING=1
	./bootstrap-nofuse.sh || die
	unset TUP_NO_NAMESPACING
}

src_install() {
	dobin tup
	dolib.a libtup_client.a
	doheader tup_client.h
	doman tup.1
}

src_test() {
	[[ -e /dev/fuse ]] || die "/dev/fuse is required for tests to work"
	# tup uses fuse when tracking dependencies.
	addwrite /dev/fuse

	# Disabling namespacing because it leads to accessing /proc/<pid>/setgroups
	# which violates sandboxing.
	export TUP_NO_NAMESPACING=1

	# Skip tests which require namespacing or root privileges.
	pushd test || die
	rm -v t2150-lua-tupdefault.sh \
		t2172-lua-relativedir.sh \
		t2187-tupdefault.sh \
		t2197-tupdefault-ghost.sh \
		t2220-lua-open-external.sh \
		t4062-full-deps.sh \
		t4063-full-deps2.sh \
		t4064-full-deps3.sh \
		t4065-full-deps-proc.sh \
		t4067-full-deps5.sh \
		t4069-gcc-coverage.sh \
		t4072-proc-self.sh \
		t4074-getpwd.sh \
		t4131-proc-self-exe.sh \
		t4132-proc-meminfo.sh \
		t4171-dev-null.sh \
		t4200-ccache.sh \
		t4201-ccache2.sh \
		t4202-clang.sh \
		t4205-full-deps6.sh \
		t4206-full-deps7.sh \
		t4207-full-deps8.sh \
		t4208-full-deps-external.sh \
		t4209-full-deps-external2.sh \
		t4210-full-deps-getaddrinfo.sh \
		t4215-full-deps-get-nprocs.sh \
		t5083-symlink-fullpath.sh \
		t5084-symlink-fullpath2.sh \
		t5103-python-sh.sh \
		t7048-full-deps.sh \
		t8105-variant-parse-progress.sh || die
	./test.sh || die
	popd || die

	unset TUP_NO_NAMESPACING
}
