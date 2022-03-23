# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs

DESCRIPTION="Efficient I/O with io_uring"
HOMEPAGE="https://github.com/axboe/liburing"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/axboe/liburing.git"
else
	SRC_URI="https://git.kernel.dk/cgit/${PN}/snapshot/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi
LICENSE="MIT"
SLOT="0/2" # liburing.so major version

IUSE="static-libs"
# fsync test hangs forever
RESTRICT="test"

# At least installed headers need <linux/*>, bug #802516
DEPEND=">=sys-kernel/linux-headers-5.1"
RDEPEND="${DEPEND}"

PATCHES=(
	# Upstream, bug #816798
	"${FILESDIR}"/${P}-arm-syscall.patch
	# Upstream, bug #829293
	"${FILESDIR}"/${P}-gnu_source-musl-cpuset.patch
)

src_prepare() {
	default

	if [[ "${PV}" != *9999 ]] ; then
		# Make sure pkgconfig files contain the correct version
		# bug #809095 and #833895
		sed -i "/^Version:/s@[[:digit:]\.]\+@${PV}@" ${PN}.spec || die
	fi

	multilib_copy_sources
}

multilib_src_configure() {
	local myconf=(
		--prefix="${EPREFIX}/usr"
		--libdir="${EPREFIX}/usr/$(get_libdir)"
		--libdevdir="${EPREFIX}/usr/$(get_libdir)"
		--mandir="${EPREFIX}/usr/share/man"
		--cc="$(tc-getCC)"
		--cxx="$(tc-getCXX)"
	)
	# No autotools configure! "econf" will fail.
	TMPDIR="${T}" ./configure "${myconf[@]}"
}

multilib_src_compile() {
	emake V=1 AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs ; then
		find "${ED}" -type f -name "*.a" -delete || die
	fi
}

multilib_src_test() {
	emake V=1 runtests
}
