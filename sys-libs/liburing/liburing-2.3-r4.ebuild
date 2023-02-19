# Copyright 1999-2023 Gentoo Authors
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	QA_PKGCONFIG_VERSION=${PV}
fi
LICENSE="MIT"
SLOT="0/2" # liburing.so major version

IUSE="examples static-libs test"
# fsync test hangs forever
RESTRICT="!test? ( test )"

# At least installed headers need <linux/*>, bug #802516
DEPEND=">=sys-kernel/linux-headers-5.1"
RDEPEND="${DEPEND}"

PATCHES=(
	# https://bugs.gentoo.org/891633
	"${FILESDIR}/${PN}-2.3-liburing.map-Export-io_uring_-enable_rings-register_.patch"
	# https://github.com/axboe/liburing/pull/787
	"${FILESDIR}/${PN}-2.3-remove-error-from-error_h-for-portability.patch"
)

src_prepare() {
	default

	if ! use examples; then
		sed -e '/examples/d' Makefile -i || die
	fi
	if ! use test; then
		sed -e '/test/d' Makefile -i || die
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
	TMPDIR="${T}" ./configure "${myconf[@]}" || die
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
	local disabled_tests=(
		accept.c
		fpos.c
		io_uring_register.c
		link-timeout.c
		read-before-exit.c
		recv-msgall-stream.c
	)
	local disabled_test
	for disabled_test in "${disabled_tests[@]}"; do
		sed -i "/\s*${disabled_test}/d" test/Makefile \
			|| die "Failed to remove ${disabled_test}"
	done

	emake -C test V=1 runtests
}
