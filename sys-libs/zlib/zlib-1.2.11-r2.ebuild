# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
AUTOTOOLS_AUTO_DEPEND="no"

inherit autotools toolchain-funcs multilib multilib-minimal

DESCRIPTION="Standard (de)compression library"
HOMEPAGE="https://zlib.net/"
SRC_URI="https://zlib.net/${P}.tar.gz
	http://www.gzip.org/zlib/${P}.tar.gz
	http://www.zlib.net/current/beta/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/1" # subslot = SONAME
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="minizip static-libs"

DEPEND="minizip? ( ${AUTOTOOLS_DEPEND} )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.11-fix-deflateParams-usage.patch
	"${FILESDIR}"/${PN}-1.2.11-mingw-w64.patch
)

src_prepare() {
	default
	if use minizip ; then
		cd contrib/minizip || die
		eautoreconf
	fi
}

echoit() { echo "$@"; "$@"; }

multilib_src_configure() {
	local uname=$("${EPREFIX}"/usr/share/gnuconfig/config.sub "${CHOST}" | cut -d- -f3) #347167
	echoit "${S}"/configure \
		--shared \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		${uname:+--uname=${uname}} \
		|| die

	if use minizip ; then
		local minizipdir="contrib/minizip"
		mkdir -p "${BUILD_DIR}/${minizipdir}" || die
		cd ${minizipdir} || die
		ECONF_SOURCE="${S}/${minizipdir}" \
		econf $(use_enable static-libs static)
	fi
}

multilib_src_compile() {
	emake
	use minizip && emake -C contrib/minizip
}

sed_macros() {
	# clean up namespace a little #383179
	# we do it here so we only have to tweak 2 files
	sed -i -r 's:\<(O[FN])\>:_Z_\1:g' "$@" || die
}

multilib_src_install() {
	emake install DESTDIR="${D}" LDCONFIG=:
	gen_usr_ldscript -a z
	sed_macros "${ED}"/usr/include/*.h

	if use minizip ; then
		emake -C contrib/minizip install DESTDIR="${D}"
		sed_macros "${ED}"/usr/include/minizip/*.h
	fi

	use static-libs || rm -f "${ED}"/usr/$(get_libdir)/lib{z,minizip}.{a,la} #419645
}

multilib_src_install_all() {
	dodoc FAQ README ChangeLog doc/*.txt
	use minizip && dodoc contrib/minizip/*.txt
}
