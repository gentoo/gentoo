# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# no support for python3_2 or above yet wrt #471326
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils multilib multilib-minimal python-single-r1

DESCRIPTION="Advanced Linux Sound Architecture Library"
HOMEPAGE="https://alsa-project.org/"
SRC_URI="https://www.alsa-project.org/files/pub/lib/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="alisp debug doc elibc_uclibc python"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.2.6 )"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	find . -name Makefile.am -exec sed -i -e '/CFLAGS/s:-g -O2::' {} + || die
	# https://bugs.gentoo.org/509886
	use elibc_uclibc && { sed -i -e 's:oldapi queue_timer:queue_timer:' test/Makefile.am || die; }
	# https://bugs.gentoo.org/545950
	sed -i -e '5s:^$:\nAM_CPPFLAGS = -I$(top_srcdir)/include:' test/lsb/Makefile.am || die
	default
	eautoreconf
}

multilib_src_configure() {
	local myconf
	# enable Python only on final ABI
	if multilib_is_native_abi; then
		myconf="$(use_enable python)"
	else
		myconf="--disable-python"
	fi
	use elibc_uclibc && myconf+=" --without-versioned"

	ECONF_SOURCE=${S} \
	econf \
		--disable-maintainer-mode \
		--enable-shared \
		--disable-resmgr \
		--enable-rawmidi \
		--enable-seq \
		--enable-aload \
		$(use_with debug) \
		$(use_enable alisp) \
		${myconf}
}

multilib_src_compile() {
	emake

	if multilib_is_native_abi && use doc; then
		emake doc
		fgrep -Zrl "${S}" doc/doxygen/html | \
			xargs -0 sed -i -e "s:${S}::"
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	if multilib_is_native_abi && use doc; then
		docinto html
		dodoc -r doc/doxygen/html/.
	fi
}

multilib_src_install_all() {
	prune_libtool_files --all
	find "${ED}"/usr/$(get_libdir)/alsa-lib -name '*.a' -exec rm -f {} +
	docinto ""
	dodoc ChangeLog doc/asoundrc.txt NOTES TODO
}
