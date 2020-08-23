# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib toolchain-funcs

DESCRIPTION="A Debug Malloc Library"
HOMEPAGE="https://dmalloc.com"
SRC_URI="https://dmalloc.com/releases/${P}.tgz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE="static-libs threads"

DEPEND="sys-apps/texinfo"
DOCS=( NEWS README docs/NOTES docs/TODO )
PATCHES=(
	# - Build objects twice, once -fPIC for shared.
	# - Use DESTDIR.
	# - Fix SONAME and NEEDED.
	"${FILESDIR}"/${P}-Makefile.in.patch
	# - Broken test, always returns false.
	"${FILESDIR}"/${P}-cxx.patch
	"${FILESDIR}"/${P}-ar.patch
	# strdup() strndup() macros
	"${FILESDIR}"/${P}-string-macros.patch
)

src_prepare() {
	default

	# - Add threads support.
	use threads && eapply "${FILESDIR}"/${P}-threads.patch

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
	econf --enable-cxx --enable-shlib $(use_enable threads)
}

src_compile() {
	default

	cd docs
	makeinfo dmalloc.texi || die
}

src_test() {
	emake heavy
}

src_install() {
	default

	newdoc ChangeLog.1 ChangeLog
	dodoc docs/dmalloc.pdf
	dodoc RELEASE.html docs/dmalloc.html
	doinfo docs/dmalloc.info

	# add missing symlinks, lazy
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so
	dosym lib${PN}.so.${PV} /usr/$(get_libdir)/lib${PN}.so.${PV%%.*}

	for lib in cxx th thcxx; do
		dosym lib${PN}${lib}.so.${PV} /usr/$(get_libdir)/lib${PN}${lib}.so
		dosym lib${PN}${lib}.so.${PV} \
			/usr/$(get_libdir)/lib${PN}${lib}.so.${PV%%.*}
	done

	if ! use static-libs; then
		rm "${ED}"/usr/$(get_libdir)/lib${PN}*.a || die
	fi
}
