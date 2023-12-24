# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/gzip.asc
inherit flag-o-matic verify-sig

DESCRIPTION="Standard GNU compressor"
HOMEPAGE="https://www.gnu.org/software/gzip/"
if [[ ${PV} == *_p* ]] ; then
	# Note: could put this in devspace, but if it's gone, we don't want
	# it in tree anyway. It's just for testing.
	MY_SNAPSHOT="$(ver_cut 1-2).31-7553"
	SRC_URI="
		https://meyering.net/gzip/gzip-${MY_SNAPSHOT}.tar.xz -> ${P}.tar.xz
		verify-sig? (
			https://meyering.net/gzip/gzip-${MY_SNAPSHOT}.tar.xz.sig -> ${P}.tar.xz.sig
		)
	"
	S="${WORKDIR}"/${PN}-${MY_SNAPSHOT}
else
	SRC_URI="
		mirror://gnu/gzip/${P}.tar.xz
		verify-sig? (
			mirror://gnu/gzip/${P}.tar.xz.sig
		)
	"
fi

LICENSE="GPL-3+"
SLOT="0"
if [[ ${PV} != *_p* ]] ; then
	KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi
IUSE="pic static"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gzip )"
RDEPEND="!app-arch/pigz[symlink(-)]"
PDEPEND="
	app-alternatives/gzip
"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.8-install-symlinks.patch"
)

src_configure() {
	use static && append-flags -static

	# Avoid text relocation in gzip
	use pic && export DEFS="NO_ASM"

	# bug #663928
	econf --disable-gcc-warnings
}

src_install() {
	default

	docinto txt
	dodoc algorithm.doc gzip.doc

	# Avoid conflict with app-arch/ncompress
	rm "${ED}"/usr/bin/uncompress || die

	# keep most things in /usr, just the fun stuff in /
	# also rename them to avoid conflict with app-alternatives/gzip
	dodir /bin
	local x
	for x in gunzip gzip zcat; do
		mv "${ED}/usr/bin/${x}" "${ED}/bin/${x}-reference" || die
	done
	mv "${ED}"/usr/share/man/man1/gzip{,-reference}.1 || die
	rm "${ED}"/usr/share/man/man1/{gunzip,zcat}.1 || die
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		local ver
		for ver in ${REPLACING_VERSIONS}; do
			if ver_test "${ver}" -lt "1.12-r2"; then
				ewarn "This package no longer installs 'uncompress'."
				ewarn "Please use 'gzip -d' to decompress .Z files."
			fi
		done
	fi

	# ensure to preserve the symlinks before app-alternatives/gzip
	# is installed
	local x
	for x in gunzip gzip zcat; do
		if [[ ! -h ${EROOT}/bin/${x} ]]; then
			ln -s "${x}-reference" "${EROOT}/bin/${x}" || die
		fi
	done
}
