# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit autotools libtool flag-o-matic python-any-r1

DESCRIPTION="Lightweight library for extracting data from files archived in a single zip file"
HOMEPAGE="http://zziplib.sourceforge.net/"
SRC_URI="https://github.com/gdraheim/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-2.1 MPL-1.1 )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc sdl static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib
	sdl? ( >=media-libs/libsdl-1.2.6 )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( app-arch/zip )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.13.69-SDL-test.patch
)

src_prepare() {
	default
	eautoreconf

	python_fix_shebang .

	# workaround AX_CREATE_PKGCONFIG_INFO bug #353195
	sed -i \
		-e '/ax_create_pkgconfig_ldflags/s:$LDFLAGS::' \
		-e '/ax_create_pkgconfig_cppflags/s:$CPPFLAGS::' \
		configure || die

	# zziplib tries to install backwards compat symlinks we dont want
	sed -i -e '/^zzip-postinstall:/s|$|\ndisable-this:|' Makefile.in || die
	sed -i -e '/^install-exec-hook:/s|$|\ndisable-this:|' zzip/Makefile.in || die

	elibtoolize

	# Do an out-of-tree build as their configure will do it automatically
	# otherwise and that can lead to funky errors. #492816
	mkdir -p build
}

src_configure() {
	cd "${S}"/build

	append-flags -fno-strict-aliasing # bug reported upstream
	export ac_cv_path_XMLTO= # man pages are bundled in .tar's

	local myeconfargs=(
		$(use_enable sdl)
		$(use_enable static-libs static)
	)

	# Disable aclocal probing as the default path works #449156
	ECONF_SOURCE=${S} ACLOCAL=true \
		econf "${myeconfargs[@]}"
	MAKEOPTS+=' -C build'
}

src_install() {
	default

	# fowners fails when we don't have enough permissions (Prefix)
	if [[ ${EUID} == 0 ]] ; then
		fowners -R root /usr/share/man #321975
	fi

	find "${ED}" -name "*.la" -delete || die

	if use doc ; then
		docinto html
		dodoc -r docs/*
	fi
}

src_test() {
	# need this because `make test` will always return true
	# tests fail with -j > 1 (bug #241186)
	emake -j1 check
}
