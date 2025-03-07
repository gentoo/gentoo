# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools systemd toolchain-funcs

DESCRIPTION="Simple FastCGI wrapper for CGI scripts (CGI support for nginx)"
HOMEPAGE="https://github.com/gnosek/fcgiwrap"
if [[ ${PV} == *_p* ]] ; then
	FCGIWRAP_COMMIT="99c942c90063c73734e56bacaa65f947772d9186"
	SRC_URI="https://github.com/gnosek/fcgiwrap/archive/${FCGIWRAP_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}"/${PN}-${FCGIWRAP_COMMIT}
else
	# https://github.com/gnosek/fcgiwrap/issues/31
	SRC_URI="https://github.com/gnosek/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="systemd"

RDEPEND="
	dev-libs/fcgi
	systemd? ( sys-apps/systemd:= )
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.rst )

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-kill.patch
	"${FILESDIR}"/${PN}-1.1.0-systemd.patch
	"${FILESDIR}"/${PN}-1.1.0-uninit-ipv6.patch
)

src_prepare() {
	default

	sed -e "s/-Werror//" \
		-i configure.ac || die "sed failed"
	sed -e '/man8dir = $(DESTDIR)/s/@prefix@//' \
		-i Makefile.in || die "sed failed"

	tc-export CC

	# Fix systemd units for Gentoo
	sed -i -e '/User/d' systemd/fcgiwrap.service || die
	sed -i -e '/Group/d' systemd/fcgiwrap.service || die

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
