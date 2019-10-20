# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs multilib-minimal

DESCRIPTION="Audio processing system for plugins to extract information from audio data"
HOMEPAGE="https://www.vamp-plugins.org"
SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/2206/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 ~sparc x86"
IUSE="doc"

RDEPEND="media-libs/libsndfile:0=[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# multilib for default search paths
	sed -i -e "s:/usr/lib/vamp:${EPREFIX}/usr/$(get_libdir)/vamp:" \
		src/vamp-hostsdk/PluginHostAdapter.cpp || die
	econf
}

multilib_src_compile() {
	emake \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"

	if multilib_is_native_abi && use doc; then
		cd build || die
		doxygen || die "creating doxygen doc failed"
		HTML_DOCS=( "${BUILD_DIR}"/build/doc/html/. )
	fi
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		INSTALL_SDK_LIBS="${EPREFIX}"/usr/$(get_libdir) \
		INSTALL_PKGCONFIG="${EPREFIX}"/usr/$(get_libdir)/pkgconfig \
		INSTALL_PLUGINS="${EPREFIX}"/usr/$(get_libdir)/vamp \
		install
}

multilib_src_install_all() {
	einstalldocs

	# don't want static archives, #474768
	find "${D}" -name '*.a' -delete || die
}

pkg_postinst() {
	elog
	elog "You might also want to install some Vamp plugins."
	elog "See media-plugins/vamp-*"
	elog
}
