# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Detect and convert encoding of text files"
HOMEPAGE="https://cihar.com/software/enca/"
SRC_URI="https://dl.cihar.com/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE="doc +iconv recode static-libs"

RDEPEND="
	iconv? ( virtual/libiconv[${MULTILIB_USEDEP}] )
	recode? ( app-text/recode[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( dev-util/gtk-doc )
"

pkg_pretend() {
	if tc-is-cross-compiler && use iconv; then
		die "${PN} can't be cross built with iconv USE enabled. See Gentoo bug 593220."
	fi
}

src_prepare() {
	default_src_prepare

	# Disable unconditional documentation build.
	sed -i -e '/SUBDIRS/s/ devel-docs//g' Makefile.am || die

	eautoreconf
}

multilib_src_configure() {
	# Workaround GCC-4.8 brokenness. See Gentoo bug 501386.
	if tc-is-gcc && [[ $(gcc-version) == "4.8" ]]; then
		replace-flags -O[3-9] -O2
	fi

	local myeconfargs=(
		--enable-external
		$(use_enable doc gtk-doc)
		$(use_enable static-libs static)
		$(use_with iconv libiconv-prefix "${EPREFIX}/usr")
		$(use_with recode librecode "${EPREFIX}/usr")
	)

	# Workaround automagic virtual/libiconv dependency.
	use iconv || export am_cv_func_iconv=no

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	# Workaround cross compilation issues. See Gentoo bug 424473.
	tc-is-cross-compiler && tc-env_build emake -e -C tools

	if ! multilib_is_native_abi; then
		emake -C lib
	else
		emake
		use doc && emake -C devel-docs docs
	fi
}

multilib_src_install() {
	if ! multilib_is_native_abi; then
		emake -C lib DESTDIR="${D}" install
		emake DESTDIR="${D}" install-pkgconfigDATA
	else
		emake DESTDIR="${D}" install
		use doc && emake -C devel-docs DESTDIR="${D}" install
	fi
	prune_libtool_files
}
