# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="A Debug Malloc Library"
HOMEPAGE="https://dmalloc.com"
SRC_URI="https://dmalloc.com/releases/${P}.tgz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="threads"

BDEPEND="sys-apps/texinfo"

PATCHES=(
	# - Build objects twice, once -fPIC for shared.
	# - Use DESTDIR.
	# - Fix SONAME and NEEDED.
	"${FILESDIR}"/${PN}-5.6.5-Makefile.in.patch
	# - Broken test, always returns false.
	"${FILESDIR}"/${PN}-5.5.2-cxx.patch
	"${FILESDIR}"/${PN}-5.6.5-configure-c99.patch
)

src_prepare() {
	default

	# - Add threads support.
	use threads && eapply "${FILESDIR}"/${PN}-5.5.2-threads.patch

	# Respect CFLAGS/LDFLAGS. #337429
	sed -i \
		-e '/libdmalloc/ s:$(CC):& $(CFLAGS) $(LDFLAGS):g' \
		-e 's|ar cr|$(AR) cr|g' \
		Makefile.in || die

	# Run autoconf for -cxx.patch.
	eautoconf
}

src_configure() {
	tc-export AR

	econf \
		--enable-cxx \
		--enable-shlib \
		$(use_enable threads)
}

src_test() {
	emake heavy
}

src_install() {
	default

	# add missing symlinks, lazy
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV%%.*}

	local lib
	for lib in cxx th thcxx; do
		dosym lib${PN}${lib}.so.${PV} /usr/$(get_libdir)/lib${PN}${lib}.so
		dosym lib${PN}${lib}.so.${PV} \
			/usr/$(get_libdir)/lib${PN}${lib}.so.${PV%%.*}
	done

	rm "${ED}"/usr/$(get_libdir)/lib${PN}*.a || die
}
