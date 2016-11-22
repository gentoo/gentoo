# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools autotools-multilib eutils multilib

DESCRIPTION="Framework to store config parameters in hierarchical key-value pairs"
HOMEPAGE="https://freedesktop.org/wiki/Software/Elektra"
SRC_URI="ftp://ftp.markus-raab.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gcov iconv static-libs test"

RDEPEND="dev-libs/libxml2[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/libtool[${MULTILIB_USEDEP}]
	iconv? ( virtual/libiconv[${MULTILIB_USEDEP}] )"

src_prepare() {
	einfo 'Removing bundled libltdl'
	rm -rf libltdl || die

	epatch \
		"${FILESDIR}"/${P}-test.patch \
		"${FILESDIR}"/${P}-ltdl.patch \
		"${FILESDIR}"/${P}-automake-1.12.patch \
		"${FILESDIR}"/${P}-remove-ddefault-link.patch

	touch config.rpath
	eautoreconf
}

src_configure() {
	# berkeleydb, daemon, fstab, gconf, python do not work
	# avoid collision with kerberos (bug 403025, 447246)
	local myeconfargs=(
		--enable-filesys
		--enable-hosts
		--enable-ini
		--enable-passwd
		--disable-berkeleydb
		--disable-fstab
		--disable-gconf
		--disable-daemon
		--enable-cpp
		--disable-python
		$(use_enable gcov)
		$(use_enable iconv)
		$(use_enable static-libs static)
		--with-docdir=/usr/share/doc/${PF}
		--with-develdocdir=/usr/share/doc/${PF}a
		--includedir=/usr/include/${PN}
	)
	autotools-multilib_src_configure
	dodir /usr/share/man/man3
}

src_compile() {
	autotools-multilib_src_compile LIBLTDL=-lltdl
}

src_install() {
	autotools-multilib_src_install

	#avoid collision with allegro (bug 409305)
	local my_f=""
	for my_f in $(find "${D}"/usr/share/man/man3 -name "key.3*") ; do
		mv "${my_f}" "${my_f/key/elektra-key}" || die
		elog "/usr/share/man/man3/$(basename "${my_f}") installed as $(basename "${my_f/key/elektra-key}")"
	done

	if ! use static-libs; then
		find "${D}" -name "*.a" -delete || die
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}
