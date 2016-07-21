# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs eutils multilib

DESCRIPTION="Audio processing plugin system for plugins that extract descriptive information from audio data"
HOMEPAGE="http://www.vamp-plugins.org"
SRC_URI="http://code.soundsoftware.ac.uk/attachments/download/690/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ~mips ppc ppc64 x86"
IUSE="doc"

RDEPEND="media-libs/libsndfile"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_prepare() {
	# multilib for default search paths
	sed -i -e "s:/usr/lib/vamp:/usr/$(get_libdir)/vamp:" src/vamp-hostsdk/PluginHostAdapter.cpp || die "sed failed"
}

src_compile() {
	emake AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)"
	if use doc; then
		cd build
		doxygen || die "creating doxygen doc failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" INSTALL_SDK_LIBS="/usr/$(get_libdir)" INSTALL_PKGCONFIG="/usr/$(get_libdir)/pkgconfig" INSTALL_PLUGINS="/usr/$(get_libdir)/vamp" install
	dodoc README* CHANGELOG
	use doc && dohtml -r build/doc/html/*
}

pkg_postinst() {
	elog ""
	elog "You might also want to install some Vamp plugins."
	elog "See media-plugins/vamp-*"
	elog ""
}
