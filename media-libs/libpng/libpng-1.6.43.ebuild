# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

APNG_REPO=apng # sometimes libpng-apng is more up to date
APNG_VERSION="1.6.43"
DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.xz
	apng? (
		mirror://sourceforge/${APNG_REPO}/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2 ${APNG_VERSION}))/${PV}/${PN}-${APNG_VERSION}-apng.patch.gz -> ${PN}-${APNG_VERSION}-${APNG_REPO}-apng.patch.gz
		mirror://sourceforge/${APNG_REPO}/${PN}$(ver_rs 1-2 '' $(ver_cut 1-2 ${APNG_VERSION}))/${PN}-${APNG_VERSION}-apng.patch.gz -> ${PN}-${APNG_VERSION}-${APNG_REPO}-apng.patch.gz
	)
"

LICENSE="libpng2"
SLOT="0/16"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="apng cpu_flags_arm_neon cpu_flags_x86_sse static-libs test"
RESTRICT="!test? ( test )"

RDEPEND=">=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"

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

multilib_src_configure() {
	local myeconfargs=(
		$(multilib_native_enable tools)
		$(use_enable test tests)
		$(use_enable cpu_flags_arm_neon arm-neon)
		$(use_enable cpu_flags_x86_sse intel-sse)
		$(use_enable static-libs static)
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default

	find "${ED}" \( -type f -o -type l \) -name '*.la' -delete || die
}
