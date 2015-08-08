# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit eutils distutils libtool toolchain-funcs

MY_P=${P/_}
DESCRIPTION="Password Checking Library"
HOMEPAGE="http://sourceforge.net/projects/cracklib"
SRC_URI="mirror://sourceforge/cracklib/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint"
IUSE="build nls python static-libs zlib"

RDEPEND="zlib? ( sys-libs/zlib )"
DEPEND="${RDEPEND}
	python? ( dev-python/setuptools )"

S=${WORKDIR}/${MY_P}

PYTHON_MODNAME="cracklib.py"
do_python() {
	use build && return 0
	use python || return 0
	case ${EBUILD_PHASE} in
	prepare|configure|compile|install)
		pushd python > /dev/null || die
		distutils_src_${EBUILD_PHASE}
		popd > /dev/null
		;;
	*)
		distutils_pkg_${EBUILD_PHASE}
		;;
	esac
}

pkg_setup() {
	# workaround #195017
	if has unmerge-orphans ${FEATURES} && has_version "<${CATEGORY}/${PN}-2.8.10" ; then
		eerror "Upgrade path is broken with FEATURES=unmerge-orphans"
		eerror "Please run: FEATURES=-unmerge-orphans emerge cracklib"
		die "Please run: FEATURES=-unmerge-orphans emerge cracklib"
	fi

	if use !build; then
		use python && python_pkg_setup
	fi
}

src_prepare() {
	elibtoolize #269003
	do_python
}

src_configure() {
	export ac_cv_header_zlib_h=$(usex zlib)
	export ac_cv_search_gzopen=$(usex zlib -lz no)
	econf \
		--with-default-dict='$(libdir)/cracklib_dict' \
		--without-python \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	do_python
}

src_install() {
	emake DESTDIR="${D}" install || die
	use static-libs || find "${ED}"/usr -name libcrack.la -delete
	rm -r "${ED}"/usr/share/cracklib

	do_python

	# move shared libs to /
	gen_usr_ldscript -a crack

	insinto /usr/share/dict
	doins dicts/cracklib-small || die

	dodoc AUTHORS ChangeLog NEWS README*
}

pkg_postinst() {
	if [[ ${ROOT} == "/" ]] ; then
		ebegin "Regenerating cracklib dictionary"
		create-cracklib-dict "${EPREFIX}"/usr/share/dict/* > /dev/null
		eend $?
	fi

	do_python
}

pkg_postrm() {
	do_python
}
