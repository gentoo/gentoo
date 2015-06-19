# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/dmalloc/dmalloc-5.5.2-r6.ebuild,v 1.8 2015/05/30 20:46:21 zlogene Exp $

EAPI=5
inherit autotools eutils multilib toolchain-funcs

DESCRIPTION="A Debug Malloc Library"
HOMEPAGE="http://dmalloc.com"
SRC_URI="http://dmalloc.com/releases/${P}.tgz"

LICENSE="CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs threads"

DEPEND="sys-apps/texinfo"
RDEPEND=""

DOCS=( NEWS README docs/NOTES docs/TODO )

src_prepare() {
	# - Build objects twice, once -fPIC for shared.
	# - Use DESTDIR.
	# - Fix SONAME and NEEDED.
	epatch "${FILESDIR}"/${P}-Makefile.in.patch

	# - Broken test, always returns false.
	epatch "${FILESDIR}"/${P}-cxx.patch
	epatch "${FILESDIR}"/${P}-ar.patch

	# - Add threads support.
	use threads && epatch "${FILESDIR}"/${P}-threads.patch

	# strdup() strndup() macros
	epatch "${FILESDIR}"/${P}-string-macros.patch

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
	insinto /usr/share/doc/${PF}
	doins docs/dmalloc.pdf
	dohtml RELEASE.html docs/dmalloc.html
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
		rm "${D}"/usr/$(get_libdir)/lib${PN}*.a || die
	fi
}
