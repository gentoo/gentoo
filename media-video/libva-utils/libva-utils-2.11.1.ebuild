# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Collection of utilities and tests for VA-API"
HOMEPAGE="https://01.org/linuxmedia/vaapi"
if [[ ${PV} = *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/intel/libva-utils"
else
	# Tarball with pre-built 'configure' not always available, portage use tarballs
	# without pre-built 'configure' as they are always avaialbe upstream.
	# SRC_URI="https://github.com/intel/libva-utils/releases/download/${PV}/${P}.tar.bz2"
	SRC_URI="https://github.com/intel/libva-utils/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+drm examples putsurface test test-va-api +vainfo wayland X"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	|| ( drm wayland X )
	putsurface? ( || ( wayland X ) )
	putsurface? ( drm )
	|| ( examples putsurface test-va-api vainfo )
"

BDEPEND="virtual/pkgconfig"

if [[ ${PV} = *9999 ]] ; then
	DEPEND="~x11-libs/libva-${PV}:=[drm?,wayland?,X?]"
else
	DEPEND=">=x11-libs/libva-$(ver_cut 1-2).0:=[drm?,wayland?,X?]"
fi

DEPEND+="
	wayland? ( >=dev-libs/wayland-1.0.6 )
	X? ( >=x11-libs/libX11-1.6.2 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-2.10.0_test_in_sandbox.patch" )

# CONTRIBUTING.md and README.md are available only in .tar.gz tarballs and in git
DOCS=( NEWS CONTRIBUTING.md README.md )

src_prepare() {
	default

	sed -e 's/-Werror//' -i test/Makefile.am || die

	if ! use examples ; then
		sed -E -e '/^SUBDIRS \+?=/s!( decode\>| encode\>| videoprocess\>| vendor/intel\>| vendor/intel/sfcsample\>)!!g' -i Makefile.am || die
	fi

	if ! use putsurface ; then
		sed -E -e '/^SUBDIRS \+?=/s! putsurface\>!!g' -i Makefile.am || die
	fi

	if ! use vainfo ; then
		sed -E -e '/^SUBDIRS \+?=/s! vainfo\>!!g' -i Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable drm)
		$(use_enable test tests)
		$(use_enable wayland)
		$(use_enable X x11)
	)

	if use test || use test-va-api ; then
		myeconfargs+=( --enable-tests )
	else
		myeconfargs+=( --disable-tests )
	fi

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	if ! use test-va-api ; then
		if [[ -e "${ED}"/usr/bin/test_va_api ]] ; then
			rm -f "${ED}"/usr/bin/test_va_api || die
		fi
	fi
}
