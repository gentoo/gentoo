# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# CRATES="
# "

# Upstream have a fork of bindgen and use cgit
# declare -A GIT_CRATES=(
# 	[bindgen]="https://gitlab.com/Matt.Jolly/rust-bindgen-bcachefs;f773267b090bf16b9e8375fcbdcd8ba5e88806a8;rust-bindgen-bcachefs-%commit%/bindgen"
# )

PYTHON_COMPAT=( python3_{10..12} )

inherit cargo flag-o-matic multiprocessing python-any-r1 toolchain-funcs unpacker

DESCRIPTION="Tools for bcachefs"
HOMEPAGE="https://bcachefs.org/"
if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://evilpiepirate.org/git/bcachefs-tools.git"
else
	MY_COMMIT=1f78fed4693a5361f56508daac59bebd5b556379
	SRC_URI="https://github.com/koverstreet/bcachefs-tools/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
		${CARGO_CRATE_URIS}"
	S="${WORKDIR}/${PN}-${MY_COMMIT}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 BSD GPL-2 MIT"
SLOT="0"
IUSE="fuse test"
RESTRICT="!test? ( test )"

DEPEND="
	app-arch/lz4
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
		S="${S}/rust-src" cargo_live_src_unpack
	else
		default
		cargo_src_unpack
	fi
}

src_prepare() {
	default
	tc-export CC
	sed \
		-e '/^CFLAGS/s:-O2::' \
		-e '/^CFLAGS/s:-g::' \
		-i Makefile || die
	# Patch our cargo-ebuild patch definition to pretend that our GIT_CRATE is upstream's URI.
	if ! [[ ${PV} == "9999" ]]; then
		sed -e 's https://gitlab.com/Matt.Jolly/rust-bindgen-bcachefs https://evilpiepirate.org/git/rust-bindgen.git ' \
			-i "${WORKDIR}/cargo_home/config" || die
	fi
	append-lfs-flags
}

src_compile() {
	use fuse && export BCACHEFS_FUSE=1
	export BUILD_VERBOSE=1
	export VERSION=${PV}

	default

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

src_install() {
	into /
	dosbin bcachefs fsck.bcachefs mkfs.bcachefs mount.bcachefs

	if use fuse; then
		dosbin mount.fuse.bcachefs
		newsbin fsck.bcachefs fsck.fuse.bcachefs
		newsbin mkfs.bcachefs mkfs.fuse.bcachefs
	fi

	doman bcachefs.8
}

pkg_postinst() {
	if use fuse; then
		ewarn "FUSE support is experimental."
		ewarn "Please only use it for development purposes at the risk of losing your data."
		ewarn "You have been warned."
	fi
}
