# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN=${PN#lib}
MY_P="${MY_PN}-${PV}"

inherit autotools eutils

DESCRIPTION="Control and monitoring library for clsync"
HOMEPAGE="http://ut.mephi.ru/oss/clsync https://github.com/xaionaro/clsync"
SRC_URI="https://github.com/xaionaro/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug extra-debug extra-hardened hardened static-libs"
S="${WORKDIR}/${MY_P}"

REQUIRED_USE="
	extra-debug? ( debug )
	extra-hardened? ( hardened )
"

DEPEND="virtual/pkgconfig"
RDEPEND="=app-doc/clsync-docs-0.4*"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	local harden_level=0
	use hardened && harden_level=1
	use extra-hardened && harden_level=2

	local debug_level=0
	use debug && debug_level=1
	use extra-debug && debug_level=2

	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--enable-socket-library \
		--disable-clsync \
		--enable-debug=${debug_level} \
		--enable-paranoid=${harden_level} \
		--without-bsm \
		--without-kqueue \
		--disable-capabilities \
		--disable-cluster \
		--enable-socket \
		--disable-highload-locks \
		--disable-unshare \
		--disable-seccomp \
		--without-libcgroup \
		--without-gio \
		--with-inotify=native \
		--without-mhash
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files
	use static-libs || find "${ED}" -name "*.a" -delete || die "failed to remove static libs"

	# docs go into clsync-docs
	rm -rf "${ED}/usr/share/doc" || die
}

pkg_postinst() {
	einfo "clsync instances you are going to use _must_ be compiled"
	einfo "with control-socket support"
}
