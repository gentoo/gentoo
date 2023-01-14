# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=""

PYTHON_COMPAT=( python3_{9..11} )

inherit cargo flag-o-matic multiprocessing python-any-r1 toolchain-funcs unpacker

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	MY_COMMIT=f1f88825c371f84edb85a156de5e1962503d23b2
	SRC_URI="https://evilpiepirate.org/git/bcachefs-tools.git/snapshot/bcachefs-tools-${MY_COMMIT}.tar.zst
		$(cargo_crate_uris ${CRATES})"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/lz4
	app-arch/zstd
	dev-libs/libaio
	dev-libs/libsodium
	dev-libs/userspace-rcu
	sys-apps/keyutils
	sys-apps/util-linux
	sys-libs/zlib
	virtual/udev
	fuse? ( >=sys-fs/fuse-3.7.0 )
"

RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/docutils[${PYTHON_USEDEP}]
		test? (
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/pytest-xdist[${PYTHON_USEDEP}]
		)
	')
	$(unpacker_src_uri_depends)
	sys-devel/clang
	virtual/rust
"

python_check_deps() {
	if use test; then
		python_has_version \
			"dev-python/pytest[${PYTHON_USEDEP}]" \
			"dev-python/pytest-xdist[${PYTHON_USEDEP}]"
	fi
	python_has_version "dev-python/docutils[${PYTHON_USEDEP}]"

}

src_unpack() {
	if [[ ${PV} == "9999" ]]; then
		git-r3_src_unpack
		local module
		for module in bch_bindgen mount; do
			S="${S}/rust-src/${module}" cargo_live_src_unpack
		done
	else
		unpacker bcachefs-tools-${MY_COMMIT}.tar.zst
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-e 's:pytest-3:/bin/true:g' \
		-i Makefile || die
	append-lfs-flags
}

src_compile() {
	use fuse && export BCACHEFS_FUSE=1
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	default

	# Rust UUID-based mounter isn't in 'all' target, may as well use ebuild functions
	local module
	for module in bch_bindgen mount; do
		pushd "${S}/rust-src/${module}" > /dev/null || die
			LIBBCACHEFS_LIB="${S}" LIBBCACHEFS_INCLUDE="${S}" cargo_src_compile
		popd > /dev/null || die
	done

	ln -f "${S}/rust-src/mount/target/release/bcachefs-mount" "${S}/mount.bcachefs" || die

	use test && emake tests
}

src_test() {
	if ! use fuse; then
		EPYTEST_IGNORE=( tests/test_fuse.py )
	fi
	EPYTEST_DESELECT=(
		# Valgrind
		'tests/test_fixture.py::test_read_after_free'
		'tests/test_fixture.py::test_undefined'
		'tests/test_fixture.py::test_write_after_free'
		'tests/test_fixture.py::test_undefined_branch'
		'tests/test_fixture.py::test_leak'
		'tests/test_fixture.py::test_check'
		# Fails in portage because of usersandbox; ensure that these pass before bumping!
		'tests/test_basic.py::test_format'
		'tests/test_basic.py::test_fsck'
		'tests/test_basic.py::test_list'
		'tests/test_basic.py::test_list_inodes'
		'tests/test_basic.py::test_list_dirent'
	)
	epytest -v -n "$(makeopts_jobs)"
}

QA_FLAGS_IGNORED="usr/bin/mount.bcachefs"
# Raised upstream; we don't expect anything to link against this outside of bcachefs-tools bins, for now
QA_SONAME=".*libbcachefs.so"

src_install() {
	exeinto /usr/bin
	local file
	for file in bcachefs fsck.bcachefs mkfs.bcachefs mount.bcachefs mount.bcachefs.sh; do
		doexe $file
	done
	dolib.so libbcachefs.so
	doman bcachefs.8
}

pkg_postinst() {
	if use fuse; then
		ewarn "FUSE support is experimental."
		ewarn "Please only use it for development purposes at the risk of losing your data."
		ewarn "You have been warned."
	fi
}
