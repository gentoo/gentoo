# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )
inherit autotools multilib-minimal python-single-r1

DESCRIPTION="Advanced Linux Sound Architecture Library"
HOMEPAGE="https://alsa-project.org/"
SRC_URI="https://www.alsa-project.org/files/pub/lib/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="alisp debug doc elibc_uclibc python +thread-safety"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

BDEPEND="doc? ( >=app-doc/doxygen-1.2.6 )"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6-missing_files.patch" #652422
	"${FILESDIR}/${P}-change-order-of-pcm-devices.patch" #718106
	"${FILESDIR}/${P}-namehint-add-omit_noargs.patch" #718106
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	find . -name Makefile.am -exec sed -i -e '/CFLAGS/s:-g -O2::' {} + || die
	# https://bugs.gentoo.org/509886
	if use elibc_uclibc ; then
		sed -i -e 's:oldapi queue_timer:queue_timer:' test/Makefile.am || die
	fi
	# https://bugs.gentoo.org/545950
	sed -i -e '5s:^$:\nAM_CPPFLAGS = -I$(top_srcdir)/include:' test/lsb/Makefile.am || die
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--disable-maintainer-mode
		--disable-resmgr
		--enable-aload
		--enable-rawmidi
		--enable-seq
		--enable-shared
		# enable Python only on final ABI
		$(multilib_native_use_enable python)
		$(use_enable alisp)
		$(use_enable thread-safety)
		$(use_with debug)
		$(usex elibc_uclibc --without-versioned '')
	)

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use doc; then
		emake doc
		grep -FZrl "${S}" doc/doxygen/html | \
			xargs -0 sed -i -e "s:${S}::" || die
	fi
}

multilib_src_install() {
	multilib_is_native_abi && use doc && local HTML_DOCS=( doc/doxygen/html/. )
	default
}

multilib_src_install_all() {
	find "${ED}" -type f \( -name '*.a' -o -name '*.la' \) -delete || die
	dodoc ChangeLog doc/asoundrc.txt NOTES TODO
}
