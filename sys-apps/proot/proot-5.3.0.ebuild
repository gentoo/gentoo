# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN="PRoot"

inherit toolchain-funcs

SRC_URI="https://github.com/proot-me/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DESCRIPTION="User-space implementation of chroot, mount --bind, and binfmt_misc"
HOMEPAGE="https://proot-me.github.io"

LICENSE="GPL-2"
SLOT="0"
IUSE="care doc test"

RDEPEND="care? ( app-arch/libarchive:0= )
	 sys-libs/talloc"
BDEPEND="dev-python/docutils"
DEPEND="${RDEPEND}
	care? ( dev-libs/uthash )
	elibc_musl? ( sys-libs/queue-standalone )
	test? ( dev-util/valgrind )"

# Breaks sandbox
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-5.3.0-makefile.patch"
	"${FILESDIR}/${PN}-5.3.0-lib-paths-fix.patch"
)

src_compile() {
	# build the proot and care targets
	emake -C src V=1 \
		CC="$(tc-getCC)" \
		OBJCOPY="$(tc-getOBJCOPY)" \
		OBJDUMP="$(tc-getOBJDUMP)" \
		STRIP="$(tc-getSTRIP)" \
		CHECK_VERSION="true" \
		CAREBUILDENV="ok" \
		proot $(use care && echo "care")
	emake -C doc SUFFIX=".py" proot/man.1
}

src_install() {
	use care && dobin src/care
	dobin src/proot
	dodoc doc/proot/*.rst
	newman doc/proot/man.1 proot.1
}

src_test() {
	emake -C tests -j1 CC="$(tc-getCC)"
}

pkg_postinst() {
	elog "If you have segfaults on recent (>4.8) kernels"
	elog "try to disable seccomp support like so:"
	elog "'export PROOT_NO_SECCOMP=1'"
	elog "prior to running proot"

	if use care; then
		elog "You have enabled 'care' USE flag, that builds and installs"
		elog "dynamically linked care binary."
		elog "Upstream does NOT support such way of building CARE,"
		elog "it provides only prebuilt binaries."
		elog "CARE also has known problems on hardened systems"
		elog "Please do NOT file bugs about them to https://bugs.gentoo.org"
	fi
}
