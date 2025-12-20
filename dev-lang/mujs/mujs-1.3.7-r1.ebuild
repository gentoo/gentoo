# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit flag-o-matic multilib python-any-r1 toolchain-funcs

DESCRIPTION="An embeddable JavaScript interpreter written in C"
HOMEPAGE="https://mujs.com/ https://codeberg.org/ccxvii/mujs"
SRC_URI="
	https://mujs.com/downloads/${P}.tar.gz
	https://www.unicode.org/Public/16.0.0/ucd/UnicodeData.txt -> ${P}-UnicodeData.txt
	https://www.unicode.org/Public/16.0.0/ucd/SpecialCasing.txt -> ${P}-SpecialCasing.txt
"

LICENSE="ISC"
# The subslot matches the SONAME
SLOT="0/${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

BDEPEND="${PYTHON_DEPS}"
RDEPEND="sys-libs/readline:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.3-flags.patch
)

src_unpack() {
	default

	# Copy these files to ${S} because otherwise the Makefile would
	# try to download them via curl, breaking the network-sandbox portage feature
	cp "${DISTDIR}/${P}-UnicodeData.txt" "${S}/UnicodeData.txt" || die "Failed moving UnicodeData.txt"
	cp "${DISTDIR}/${P}-SpecialCasing.txt" "${S}/SpecialCasing.txt" || die "Failed moving SpecialCasing.txt"
}

src_prepare() {
	default

	tc-export AR CC

	append-cflags -fPIC

	# The library's ABI (and API) might change in new releases
	# Diff 'usr/include/mujs.h' across releases to validate
	if [[ ${CHOST} == *-darwin* ]] ; then
		append-cflags -Wl,-install_name,"${EPREFIX}"/usr/$(get_libdir)/lib${PN}.${PV}.dylib
	else
		append-cflags -Wl,-soname=lib${PN}.so.${PV}
	fi
}

src_compile() {
	# We need to use ${PV} for the pkgconfig file, see: #784461
	makeargs=(
		VERSION=${PV}
		XCFLAGS="${CFLAGS}"
		XLDFLAGS="${LDFLAGS}"
		prefix="${EPREFIX}/usr"
		libdir="\$(prefix)/$(get_libdir)"
	)
	emake "${makeargs[@]}" release
}

src_install() {
	emake "${makeargs[@]}" DESTDIR="${D}" install-shared

	mv -v "${ED}"/usr/$(get_libdir)/lib${PN}$(get_libname) \
		"${ED}"/usr/$(get_libdir)/lib${PN}$(get_libname ${PV}) \
		|| die "Failed adding version suffix to mujs shared library"
	dosym lib${PN}$(get_libname ${PV}) "${EPREFIX}/usr/$(get_libdir)/lib${PN}$(get_libname)"
	dosym lib${PN}$(get_libname ${PV}) "${EPREFIX}/usr/$(get_libdir)/lib${PN}$(get_libname ${PV:0:1})"
}
