# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd toolchain-funcs

DESCRIPTION="Simple FastCGI wrapper for CGI scripts (CGI support for nginx)"
HOMEPAGE="https://github.com/gnosek/fcgiwrap"
SRC_URI="https://github.com/gnosek/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~x86"
SLOT="0"
IUSE="systemd"

RDEPEND="
	dev-libs/fcgi
	systemd? ( sys-apps/systemd )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.rst )

src_prepare() {
	sed -e "s/-Werror//" \
		-i configure.ac || die "sed failed"

	sed -e '/man8dir = $(DESTDIR)/s/@prefix@//' \
		-i Makefile.in || die "sed failed"

	sed -e "s/libsystemd-daemon/libsystemd/" \
		-i configure.ac || die "sed failed"
	tc-export CC

	# Fix systemd units for Gentoo
	sed -i -e '/User/d' systemd/fcgiwrap.service || die
	sed -i -e '/Group/d' systemd/fcgiwrap.service || die

	eapply_user
	eautoreconf
}

src_configure() {
	econf \
		$(use_with systemd) \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

pkg_postinst() {
	einfo "You may want to install www-servers/spawn-fcgi to use with fcgiwrap."
}
