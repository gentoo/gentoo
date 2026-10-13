# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a libtool multilib-minimal

APNG_REPO=libpng-apng # sometimes libpng-apng is more up to date
APNG_VERSION="1.6.54"
DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="https://www.libpng.org/"
SRC_URI="
	https://downloads.sourceforge.net/${PN}/${P}.tar.xz
	apng? (
		https://downloads.sourceforge.net/${APNG_REPO}/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2 ${APNG_VERSION}))/${PV}/${PN}-${APNG_VERSION}-apng.patch.gz -> ${PN}-${APNG_VERSION}-${APNG_REPO}-apng.patch.gz
		https://downloads.sourceforge.net/${APNG_REPO}/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2 ${APNG_VERSION}))/${PN}-${APNG_VERSION}-apng.patch.gz -> ${PN}-${APNG_VERSION}-${APNG_REPO}-apng.patch.gz
	)
"

LICENSE="libpng2"
SLOT="0/16"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="apng cpu_flags_x86_sse static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=">=virtual/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]"
DEPEND="
	${RDEPEND}
	riscv? ( sys-kernel/linux-headers )
"

DOCS=( ANNOUNCE CHANGES libpng-manual.txt README TODO )

src_prepare() {
	default

	if use apng; then
		case ${APNG_REPO} in
			apng)
				eapply -p0 "${WORKDIR}"/${PN}-${APNG_VERSION}-${APNG_REPO}-apng.patch
				;;
			libpng-apng)
				eapply "${WORKDIR}"/${PN}-${APNG_VERSION}-${APNG_REPO}-apng.patch
				;;
			*)
				die "Unknown APNG_REPO!"
				;;
		esac

		# Don't execute symbols check with apng patch, bug #378111
		sed -i -e '/^check/s:scripts/symbols.chk::' Makefile.in || die
	fi

	elibtoolize
}

src_configure() {
	lto-guarantee-fat
	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_native_enable tools)
		$(use_enable test tests)
		$(use_enable cpu_flags_x86_sse intel-sse)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default

	strip-lto-bytecode
	find "${ED}" \( -type f -o -type l \) -name '*.la' -delete || die
}
