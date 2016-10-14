# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs eutils multilib multilib-minimal

DESCRIPTION="Audio processing plugin system for plugins that extract descriptive information from audio data"
HOMEPAGE="http://www.vamp-plugins.org"
SRC_URI="https://code.soundsoftware.ac.uk/attachments/download/1514/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~mips ppc ppc64 x86"
IUSE="doc static-libs"

RDEPEND="media-libs/libsndfile"
DEPEND="${RDEPEND}
	media-libs/libsndfile[${MULTILIB_USEDEP}]
	doc? ( app-doc/doxygen )"

src_prepare() {
	multilib_copy_sources
}

multilib_src_configure() {
	# multilib for default search paths
	sed -i -e "s:/usr/lib/vamp:/usr/$(get_libdir)/vamp:" src/vamp-hostsdk/PluginHostAdapter.cpp || die "sed failed"
	econf
}

multilib_src_compile() {
	emake AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"

	if multilib_is_native_abi && use doc; then
		cd build
		doxygen || die "creating doxygen doc failed"
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" INSTALL_SDK_LIBS="/usr/$(get_libdir)" INSTALL_PKGCONFIG="/usr/$(get_libdir)/pkgconfig" INSTALL_PLUGINS="/usr/$(get_libdir)/vamp" install
	multilib_is_native_abi && use doc && dohtml -r build/doc/html/*
}

multilib_src_install_all() {
	dodoc README* CHANGELOG
}

pkg_postinst() {
	elog ""
	elog "You might also want to install some Vamp plugins."
	elog "See media-plugins/vamp-*"
	elog ""
}
