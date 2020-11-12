# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} pypy3 )

if [[ ${PV} == *9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/erikd/libsndfile.git"
else
	SRC_URI="https://github.com/erikd/libsndfile/releases/download/v${PV}/${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
fi
inherit python-any-r1 multilib-minimal

DESCRIPTION="C library for reading and writing files containing sampled sound"
HOMEPAGE="http://www.mega-nerd.com/libsndfile"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="alsa minimal sqlite static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	!minimal? (
		media-libs/flac:=[${MULTILIB_USEDEP}]
		media-libs/libogg:=[${MULTILIB_USEDEP}]
		media-libs/libvorbis:=[${MULTILIB_USEDEP}]
		media-libs/opus:=[${MULTILIB_USEDEP}]
	)
	alsa? ( media-libs/alsa-lib:= )
	sqlite? ( dev-db/sqlite )"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )"
if [[ ${PV} == *9999 ]]; then
	BDEPEND+="
		${PYTHON_DEPS}
		sys-devel/autogen
	"
fi

pkg_setup() {
	if use test || [[ ${PV} == *9999 ]]; then
		python-any-r1_pkg_setup
	fi
}

src_prepare() {
	default

	[[ ${PV} == *9999 ]] && eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		--disable-octave \
		--disable-werror \
		$(use_enable static-libs static) \
		$(use_enable !minimal external-libs) \
		$(multilib_native_enable full-suite) \
		$(multilib_native_use_enable alsa) \
		$(multilib_native_use_enable sqlite) \
		PYTHON="${EPYTHON}"
}

multilib_src_install_all() {
	einstalldocs

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
