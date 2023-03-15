# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools tmpfiles

DESCRIPTION="A multi-threaded implementation of Apple's DAAP server"
HOMEPAGE="https://sourceforge.net/projects/mt-daapd/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux"
IUSE="vorbis"

RDEPEND="
	media-libs/libid3tag:=
	net-dns/avahi[dbus]
	sys-libs/gdbm:=
	sys-libs/zlib:=
	vorbis? (
		media-libs/libvorbis
		media-libs/libogg
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/byacc
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.2.3-sparc.patch
	"${FILESDIR}"/${PN}-0.2.4.1-libsorder.patch
	"${FILESDIR}"/${PN}-0.2.4.1-pidfile.patch
	"${FILESDIR}"/${P}-maintainer-mode.patch
	"${FILESDIR}"/${P}-oggvorbis.patch
	"${FILESDIR}"/${P}-clang16.patch
	"${FILESDIR}"/${P}-musl.patch
)

src_prepare() {
	default

	# parser.y is fixed by the clang16 patch, force regeneration
	rm src/parser.c || die

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# Incompatible with Bison 3, dead upstream
	export YACC=byacc

	econf \
		$(use_enable vorbis oggvorbis) \
		--disable-maintainer-mode \
		--enable-avahi \
		--disable-mdns
}

src_install() {
	default

	insinto /etc
	newins contrib/mt-daapd.conf mt-daapd.conf.example
	doins contrib/mt-daapd.playlist

	newinitd "${FILESDIR}"/${PN}.init.2 ${PN}

	keepdir /etc/mt-daapd.d

	newtmpfiles "${FILESDIR}"/mt-daapd.tmpfiles mt-daapd.conf
}

pkg_postinst() {
	tmpfiles_process mt-daapd.conf

	elog
	elog "You have to configure your mt-daapd.conf following"
	elog "${EROOT}/etc/mt-daapd.conf.example file."
	elog

	if use vorbis; then
		elog
		elog "You need to edit you extensions list in ${EROOT}/etc/mt-daapd.conf"
		elog "if you want your mt-daapd to serve ogg files."
		elog
	fi

	elog
	elog "If you want to start more than one ${PN} service, symlink"
	elog "${EROOT}/etc/init.d/${PN} to ${EROOT}/etc/init.d/${PN}.<name>, and it will"
	elog "load the data from ${EROOT}/etc/${PN}.d/<name>.conf."
	elog "Make sure that you have different cache directories for them."
	elog
}
