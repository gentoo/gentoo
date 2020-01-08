# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib

DESCRIPTION="Lightweight, robust, and efficient POSIX compliant regexp matching library"
HOMEPAGE="https://laurikari.net/tre/ https://github.com/laurikari/tre/"
SRC_URI="https://laurikari.net/tre/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="nls static-libs"

RDEPEND="
	!app-text/agrep
	!dev-ruby/amatch
	!app-misc/glimpse"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=( "${FILESDIR}/${PV}-pkgcfg.patch" )

src_prepare() {
	default
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

	# 626480
	mv "${ED%/}"/usr/bin/agrep{,-tre}$(get_exeext) || die
}

pkg_postinst() {
	ewarn "app-misc/glimpse, app-text/agrep and this package all provide agrep."
	ewarn "If this causes any unforeseen incompatibilities please file a bug"
	ewarn "on https://bugs.gentoo.org."
}
