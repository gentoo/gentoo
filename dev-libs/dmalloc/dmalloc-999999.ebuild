# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 toolchain-funcs

DESCRIPTION="A Debug Malloc Library"
HOMEPAGE="https://dmalloc.com"
EGIT_REPO_URI="https://github.com/j256/dmalloc"

LICENSE="ISC"
SLOT="0"
IUSE="threads"

BDEPEND="
	app-text/texi2html
	sys-apps/texinfo
"

DOCS=(
	ChangeLog.txt README.md TODO dmalloc.html
)

PATCHES=(
	# - Build objects twice, once -fPIC for shared.
	# - Use DESTDIR.
	# - Fix SONAME and NEEDED.
	"${FILESDIR}"/${PN}-5.5.2-Makefile.in.patch
	# - Broken test, always returns false.
	"${FILESDIR}"/${PN}-5.5.2-cxx.patch
	"${FILESDIR}"/${PN}-5.5.2-ar.patch
	"${FILESDIR}"/${PN}-999999-texi2html.patch
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

src_compile() {
	default

	#makeinfo dmalloc.texi || die
}

src_test() {
	emake heavy
}

src_install() {
	default

	doinfo dmalloc.info

	# add missing symlinks, lazy
	dosym lib${PN}.so.5.5.2 /usr/$(get_libdir)/lib${PN}.so
	dosym lib${PN}.so.5.5.2 /usr/$(get_libdir)/lib${PN}.so.5

	for lib in cxx th thcxx; do
		dosym lib${PN}${lib}.so.5.5.2 /usr/$(get_libdir)/lib${PN}${lib}.so
		dosym lib${PN}${lib}.so.5.5.2 \
			/usr/$(get_libdir)/lib${PN}${lib}.so.5
	done

	rm "${ED}"/usr/$(get_libdir)/lib${PN}*.a || die
}
