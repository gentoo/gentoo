# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Lightweight, robust, and efficient POSIX compliant regexp matching library"
HOMEPAGE="http://laurikari.net/tre/ https://github.com/laurikari/tre/"
SRC_URI="http://laurikari.net/tre/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="nls static-libs"

RDEPEND="
	!app-misc/glimpse
	!app-text/agrep"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	eapply \
		"${FILESDIR}"/${PV}-pkgcfg.patch
	eapply_user
}

src_configure() {
	econf \
		--enable-agrep \
		--enable-system-abi \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_test() {
	if locale -a | grep -iq en_US.iso88591; then
		emake -j1 check
	else
		ewarn "If you like to run the test,"
		ewarn "please make sure en_US.ISO-8859-1 is installed."
		die "en_US.ISO-8859-1 locale is missing"
	fi
}

src_install() {
	local HTML_DOCS=( doc/*.{css,html} )
	default

	mv "${ED%/}"/usr/bin/agrep{,-tre}$(get_exeext) || die
}

pkg_postinst() {
	ewarn "app-misc/glimpse, app-text/agrep and this package all provide agrep."
	ewarn "If this causes any unforeseen incompatibilities please file a bug"
	ewarn "on https://bugs.gentoo.org."
}
