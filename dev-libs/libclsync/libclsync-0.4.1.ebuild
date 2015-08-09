# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN=${PN#lib}
MY_P="${MY_PN}-${PV}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/xaionaro/${MY_PN}.git"
else
	SRC_URI="https://github.com/xaionaro/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_P}"
fi

inherit autotools

DESCRIPTION="Control and monitoring library for clsync"
HOMEPAGE="http://ut.mephi.ru/oss/clsync https://github.com/xaionaro/clsync"
LICENSE="GPL-3+"
SLOT="0"
IUSE="debug extra-debug extra-hardened hardened static-libs"
REQUIRED_USE="
	extra-debug? ( debug )
	extra-hardened? ( hardened )
"

DEPEND="virtual/pkgconfig "
RDEPEND="=app-doc/clsync-docs-0.4*"

src_prepare() {
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
