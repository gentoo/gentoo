# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/coldsync/coldsync-3.0_pre4.ebuild,v 1.8 2014/06/24 13:20:49 ssuominen Exp $

EAPI=5
inherit flag-o-matic eutils perl-module toolchain-funcs

MY_P=${PN}-${PV/_/-}

DESCRIPTION="A command-line tool to synchronize PalmOS PDAs with Unix workstations"
HOMEPAGE="http://www.coldsync.org/"
SRC_URI="http://www.coldsync.org/download/${MY_P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="caps nls perl usb"

RDEPEND="caps? ( sys-libs/libcap )
	perl? ( dev-lang/perl )
	usb? ( virtual/libusb:0 )"
DEPEND="${RDEPEND}
	sys-apps/texinfo
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-texinfo-5.patch

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_prepare
		popd
	fi
}

src_configure() {
	tc-export CC CXX
	append-cflags -fno-strict-aliasing
	# FIXME: Fails to link later because libpconn is underlinked with USE="usb".
	append-ldflags $(no-as-needed)

	econf \
		$(use_with nls i18n) \
		$(use_with caps capabilities) \
		$(use_with usb libusb) \
		--without-perl

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_configure
		popd
	fi
}

src_compile() {
	emake -j1 #279292

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_compile
		popd
	fi
}

src_install() {
	emake \
		PREFIX="${D}"/usr \
		MANDIR="${D}"/usr/share/man \
		SYSCONFDIR="${D}"/etc \
		DATADIR="${D}"/usr/share \
		INFODIR="${D}"/usr/share/info \
		INSTALLMAN3DIR="${D}"/usr/share/man/man3 \
		INSTALLSITEMAN3DIR="${D}"/usr/share/man/man3 \
		INSTALLVENDORMAN3DIR="${D}"/usr/share/man/man3 \
		EXTRA_INFOFILES="" \
		install

	if use perl; then
		pushd perl/ColdSync
		perl-module_src_install
		popd
	fi

	dodoc AUTHORS ChangeLog FAQ HACKING NEWS README* TODO
}
