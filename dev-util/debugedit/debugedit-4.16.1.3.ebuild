# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_P=rpm-${PV}
DESCRIPTION="Stand-alone debugedit from RPM"
HOMEPAGE="https://rpm.org
	https://github.com/rpm-software-management/rpm"
SRC_URI="http://ftp.rpm.org/releases/rpm-$(ver_cut 1-2).x/${MY_P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	sys-libs/zlib:=
	>=dev-libs/popt-1.7
	>=dev-libs/elfutils-0.176-r1
	dev-libs/nss
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_P}

src_prepare() {
	eapply_user

	# cheat it into believing we're bundling db
	mkdir -p db/dist || die
	touch db/dist/configure || die
	chmod +x db/dist/configure || die
	echo 'install:' > db3/Makefile || die

	# TODO: why do we need to do this?
	mkdir rpm || die
	find -name '*.h' -exec cp {} rpm/ ';' || die
}

src_configure() {
	append-cppflags -I"${EPREFIX}/usr/include/nss" -I"${EPREFIX}/usr/include/nspr"
	local myconf=(
		# force linking to static librpmio
		--disable-shared

		# disable linking compression libraries
		ac_cv_header_bzlib_h=no
		ac_cv_header_lzma_h=no
		--disable-zstd

		# fake some libraries we don't use
		ac_cv_header_magic_h=yes
		ac_cv_lib_magic_magic_open=yes

		# use nss as crypto provider
		--with-crypto=nss

		# disable other stuff irrelevant to debugedit
		--disable-bdb
		--disable-nls
		--disable-plugins
		--disable-python
		--without-acl
		--without-archive
		--without-cap
		--without-external-db
		--without-hackingdocs
		--without-lua
		--without-selinux
	)
	econf "${myconf[@]}"
}

src_compile() {
	emake -C misc
	emake -C rpmio
	emake debugedit
}

src_test() {
	:
}

src_install() {
	dobin debugedit
}
