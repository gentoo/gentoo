# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A Debug Malloc Library"
HOMEPAGE="https://dmalloc.com"
SRC_URI="https://dmalloc.com/releases/${P}.tgz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="threads"

BDEPEND="sys-apps/texinfo"

PATCHES=(
	"${FILESDIR}"/${PN}-5.6.5-add-destdir-support.patch
	"${FILESDIR}"/${PN}-5.6.5-allow-overriding-ar-and-ld.patch
	"${FILESDIR}"/${PN}-5.6.5-set-soname-version.patch
	"${FILESDIR}"/${PN}-5.6.5-configure-c99.patch
	"${FILESDIR}"/${PN}-5.6.5-fix-cxx-check.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	append-cflags $(test-flags-CC -fPIC)

	econf \
		--enable-cxx \
		--enable-shlib \
		$(use_enable threads)
}

src_test() {
	# mv: cannot stat 'aout': No such file or directory
	emake -j1 heavy
}

src_install() {
	default

	soname_link() {
		dosym ${1}.so.${PV} /usr/$(get_libdir)/${1}.so.${PV%%.*}
		dosym ${1}.so.${PV%%.*} /usr/$(get_libdir)/${1}.so
	}

	soname_link libdmalloc
	soname_link libdmallocxx

	if use threads; then
		soname_link libdmallocth
		soname_link libdmallocthcxx
	fi

	rm "${ED}"/usr/$(get_libdir)/lib${PN}*.a || die
}
